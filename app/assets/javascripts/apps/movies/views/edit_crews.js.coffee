class MoviesApp.EditCrews extends Backbone.View
  template: JST['templates/crews/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-crew-save" : "create"
    "click .js-crew-remove" : "destroy"

  render: ->
    edit = $(@el)
    crews = @options.crews
    edit.html @template(crews: crews)
    this

  create: (e) ->
    console.log "create"
    self = @
    job = $(@el).find(".js-new-crew-job").val()
    person_id = $(@el).find(".js-new-crew-person").val()
    crew = new MoviesApp.Crew()
    crew.save ({ crew: { job: job, person_id: person_id, movie_id: movie_id } }),
      success: ->
        $(".notifications").html("Crew member added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-crew-job").val("")
        $(self.el).find(".js-new-crew-person").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "crews/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Crew member removed.").show().fadeOut(10000)
