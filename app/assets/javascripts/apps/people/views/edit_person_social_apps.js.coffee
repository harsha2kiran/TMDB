class PeopleApp.EditPersonSocialApps extends Backbone.View
  template: JST['templates/person_social_apps/edit']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-person-social-app-save" : "create"
    "click .js-person-social-app-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    person_social_apps = @options.person_social_apps
    @edit.html @template(person_social_apps: person_social_apps)

    self = @
    $(@el).find(".js-new-person-social-apps-app").autocomplete
      source: api_version + "social_apps/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        if ui.item.id == "0"
          self.add_new_item()
        $(self.el).find(".js-new-person-social-apps-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-person-social-apps-app").val()), "social app")
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-person-social-apps-app-id").val("")
        else
          self.edit.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: (e) ->
    console.log "create"
    self = @
    app_id = $(@el).find(".js-new-person-social-apps-id").val()
    profile_link = $(@el).find(".js-new-person-social-apps-link").val()
    if app_id != "" && profile_link != ""
      person_social_app = new PeopleApp.PersonSocialApp()
      person_social_app.save ({ person_social_app: { social_app_id: app_id, person_id: window.person_id, profile_link: profile_link, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Social app link added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("This social app link already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-person-social-apps-app-id").val("").removeClass("error")
          $(self.el).find(".js-new-person-social-apps-app").val("").removeClass("error")
          $(self.el).find(".js-new-person-social-apps-link").val("").removeClass("error")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  reload_items: ->
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{window.person_id}/my_person"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        person = person.get("person")
        $(@el).remove()
        @stopListening()
        @edit_person_social_apps_view = new PeopleApp.EditPersonSocialApps(person_social_apps: person.person_social_apps)
        $(".person-social-apps").html @edit_person_social_apps_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".col-md-12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "person_social_apps/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Social app link removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-person-social-apps-app").val()
    link = @edit.find(".js-new-person-social-apps-link").val()
    if value != ""
      model = new PeopleApp.SocialApp()
      model.save ({ social_app: { social_app: value, link: link } }),
        success: ->
          $(".notifications").html("Social App added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-person-social-apps-app").val(value).removeClass "error"
          $(self.el).find(".js-new-person-social-apps-id").val(model.id)
          $(self.el).find(".js-new-person-social-apps-link").val(link).removeClass("error")
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Social app is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-person-social-apps-app").val("").removeClass "error"
          $(self.el).find(".js-new-person-social-apps-id").val("")
          $(self.el).find(".js-new-person-social-apps-link").val("").removeClass("error")
          self.cancel()
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


