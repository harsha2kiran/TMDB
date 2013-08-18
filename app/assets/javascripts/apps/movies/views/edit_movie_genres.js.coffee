class MoviesApp.EditMovieGenres extends Backbone.View
  template: JST['templates/movie_genres/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-genre-save" : "create"
    "click .js-genre-remove" : "destroy"

  render: ->
    edit = $(@el)
    movie_genres = @options.movie_genres
    edit.html @template(movie_genres: movie_genres)

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

    this

  create: (e) ->
    self = @
    genre_id = $(@el).find(".js-new-genre-id").val()
    if genre_id
      movie_genre = new MoviesApp.MovieGenre()
      movie_genre.save ({ movie_genre: { genre_id: genre_id, movie_id: movie_id } }),
        success: ->
          $(".notifications").html("Genre added. It will be active after moderation.").show().fadeOut(10000)
          $(self.el).find(".js-new-genre").val("").removeClass "error"
          $(self.el).find(".js-new-genre-id").val("")
    else
      $(@el).find(".js-new-genre").addClass("error")


  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_genres/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Genre removed.").show().fadeOut(10000)
