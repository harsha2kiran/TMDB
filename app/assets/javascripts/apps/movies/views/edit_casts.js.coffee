class MoviesApp.EditCasts extends Backbone.View
  template: JST['templates/casts/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-cast-save" : "create"
    "click .js-cast-remove" : "destroy"

  render: ->
    edit = $(@el)
    casts = @options.casts
    edit.html @template(casts: casts)

    self = @
    $(@el).find(".js-new-cast-person").autocomplete
      source: api_version + "people/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-cast-person-id").val(ui.item.id)

    this

  create: (e) ->
    self = @
    character = $(@el).find(".js-new-cast-character").val()
    person_id = $(@el).find(".js-new-cast-person-id").val()
    cast = new MoviesApp.Cast()
    cast.save ({ cast: { character: character, person_id: person_id, movie_id: movie_id } }),
      success: ->
        $(".notifications").html("Cast member added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-cast-character").val("")
        $(self.el).find(".js-new-cast-person").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "casts/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Cast member removed.").show().fadeOut(10000)
