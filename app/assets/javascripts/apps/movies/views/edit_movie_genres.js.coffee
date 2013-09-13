class MoviesApp.EditMovieGenres extends Backbone.View
  template: JST['templates/movie_genres/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-genre-save" : "create"
    "click .js-genre-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    movie_genres = @options.movie_genres
    @edit.html @template(movie_genres: movie_genres)

    self = @
    $(@el).find(".js-new-genre").autocomplete
      source: api_version + "genres/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-genre-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-genre-id").val("")
    this

  create: (e) ->
    self = @
    genre_id = $(@el).find(".js-new-genre-id").val()
    if genre_id
      movie_genre = new MoviesApp.MovieGenre()
      movie_genre.save ({ movie_genre: { genre_id: genre_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Genre added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-genre").val("").removeClass "error"
          $(self.el).find(".js-new-genre-id").val("")
          self.reload_items()
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Genre already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-genre").val("").removeClass "error"
          $(self.el).find(".js-new-genre-id").val("")
    else
      $(@el).find(".js-new-genre").addClass("error")

  reload_items: ->
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{window.movie_id}"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        movie = movie.get("movie")
        $(@el).remove()
        @stopListening()
        @edit_movie_genres_view = new MoviesApp.EditMovieGenres(movie_genres: movie.movie_genres)
        $(".genres").html @edit_movie_genres_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_genres/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Genre removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-genre").val()
    if value != ""
      model = new MoviesApp.Genre()
      model.save ({ genre: { genre: value } }),
        success: ->
          $(".notifications").html("Genre added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-genre").val(value).removeClass "error"
          $(self.el).find(".js-new-genre-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Genre is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-genre").val("").removeClass "error"
          $(self.el).find(".js-new-genre-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-genre").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


