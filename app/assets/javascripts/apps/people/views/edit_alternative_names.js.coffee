class PeopleApp.EditAlternativeNames extends Backbone.View
  template: JST['templates/alternative_names/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-alternative-name-save" : "create"
    "click .js-alternative-name-remove" : "destroy"

  render: ->
    edit = $(@el)
    alternative_names = @options.alternative_names
    edit.html @template(alternative_names: alternative_names)
    this

  create: (e) ->
    console.log "create"
    self = @
    name = $(@el).find(".js-new-alternative-name").val()
    if name != ""
      alternative_name = new PeopleApp.AlternativeName()
      alternative_name.save ({ alternative_name: { alternative_name: name, person_id: window.person_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Alternative name added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: ->
          console.log "error"
          $(".notifications").html("This alternative name already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-alternative-name").val("").removeClass("error")
    else
      $(self.el).find(".js-new-alternative-name").addClass("error")

  reload_items: ->
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{window.person_id}"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        person = person.get("person")
        $(@el).remove()
        @stopListening()
        @edit_alternative_names_view = new PeopleApp.EditAlternativeNames(alternative_names: person.alternative_names)
        $(".alternative-names").html @edit_alternative_names_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "alternative_names/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Alternative name removed.").show().fadeOut(window.hide_delay)
