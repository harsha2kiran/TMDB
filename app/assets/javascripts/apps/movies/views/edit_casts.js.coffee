class MoviesApp.EditCasts extends Backbone.View
  template: JST['templates/casts/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-cast-save" : "create"
    "click .js-cast-remove" : "destroy"
    "click .js-new-movie-add-yes" : "add_new_movie"
    "click .js-new-movie-add-no" : "cancel"
    "click .js-new-person-add-yes" : "add_new_person"
    "click .js-new-person-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    casts = @options.casts
    @edit.html @template(casts: casts)

    self = @
    $(@el).find(".js-new-cast-person").autocomplete
      source: api_version + "people/search?temp_user_id=" + localStorage.temp_user_id
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-cast-person-id").val(ui.item.id)
      response: (event, ui) ->
        if ui.content.length == 0
          $(self.el).find(".js-new-person-info, .js-new-person-add-form").show()
          $(self.el).find(".js-new-person-id").val("")
        else
          self.edit.find(".js-new-person-info, .js-new-person-add-form").hide()

    $(@el).find(".js-new-cast-movie").autocomplete
      source: api_version + "movies/search?temp_user_id=" + localStorage.temp_user_id
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-cast-movie-id").val(ui.item.id)
      response: (event, ui) ->
        if ui.content.length == 0
          $(self.el).find(".js-new-movie-info, .js-new-movie-add-form").show()
          $(self.el).find(".js-new-movie-id").val("")
        else
          self.edit.find(".js-new-movie-info, .js-new-movie-add-form").hide()
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
          self.reload_items()
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

  reload_items: ->
    if window.movie_id
      movie = new MoviesApp.Movie()
      movie.url = "/api/v1/movies/#{window.movie_id}/my_movie"
      movie.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          movie = movie.get("movie")
          $(@el).remove()
          @stopListening()
          @edit_casts_view = new MoviesApp.EditCasts(casts: movie.casts)
          $(".cast").html @edit_casts_view.render().el
    else if window.person_id
      person = new PeopleApp.Person()
      person.url = "/api/v1/people/#{window.person_id}/my_person"
      person.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          person = person.get("person")
          $(@el).remove()
          @stopListening()
          @edit_casts_view = new MoviesApp.EditCasts(casts: person.casts)
          $(".cast").html @edit_casts_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "casts/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Cast member removed.").show().fadeOut(window.hide_delay)

  add_new_movie: (e) ->
    self = @
    value = @edit.find(".js-new-cast-movie").val()
    if value != ""
      model = new MoviesApp.Movie()
      model.save ({ movie: { title: value, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Movie added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-movie").val(value).removeClass "error"
          $(self.el).find(".js-new-cast-movie-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Movie is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-movie").val("").removeClass "error"
          $(self.el).find(".js-new-cast-movie-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-movie").addClass("error")

  add_new_person: (e) ->
    self = @
    value = @edit.find(".js-new-cast-person").val()
    if value != ""
      model = new PeopleApp.Person()
      model.save ({ person: { name: value, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Person added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-person").val(value).removeClass "error"
          $(self.el).find(".js-new-cast-person-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Person is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-cast-person").val("").removeClass "error"
          $(self.el).find(".js-new-cast-person-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-cast-person").addClass("error")

  cancel: ->
    @edit.find(".js-new-person-info, .js-new-person-add-form").hide()
    @edit.find(".js-new-movie-info, .js-new-movie-add-form").hide()

