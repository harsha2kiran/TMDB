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
      alternative_name.save ({ alternative_name: { alternative_name: name, person_id: window.person_id } }),
        success: ->
          $(".notifications").html("Alternative name added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-alternative-name").val("").removeClass("error")
    else
      $(self.el).find(".js-new-alternative-name").addClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "alternative_names/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Alternative name removed.").show().fadeOut(window.hide_delay)
