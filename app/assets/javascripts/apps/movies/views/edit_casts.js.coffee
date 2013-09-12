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

    $(@el).find(".js-new-cast-movie").autocomplete
      source: api_version + "movies/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-cast-movie-id").val(ui.item.id)
    this

  create: (e) ->
    self = @
    character = $(@el).find(".js-new-cast-character").val()
    if window.movie_id
      person_id = $(@el).find(".js-new-cast-person-id").val()
      movie_id = window.movie_id
    else if window.person_id
      person_id = window.person_id
      movie_id = $(@el).find(".js-new-cast-movie-id").val()
    if character != "" && person_id != "" && movie_id != ""
      cast = new MoviesApp.Cast()
      cast.save ({ cast: { character: character, person_id: person_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Cast member added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-character").val("").removeClass("error")
          $(self.el).find(".js-new-cast-person").val("").removeClass("error")
          $(self.el).find(".js-new-cast-person-id").val("")
          $(self.el).find(".js-new-cast-movie").val("").removeClass("error")
          $(self.el).find(".js-new-cast-movie-id").val("")
        error: ->
          console.log "error"
          $(".notifications").html("This cast member already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-character").val("").removeClass("error")
          $(self.el).find(".js-new-cast-person").val("").removeClass("error")
          $(self.el).find(".js-new-cast-person-id").val("")
          $(self.el).find(".js-new-cast-movie").val("").removeClass("error")
          $(self.el).find(".js-new-cast-movie-id").val("")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "casts/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Cast member removed.").show().fadeOut(window.hide_delay)
