class MoviesApp.Router extends Backbone.Router

  routes:
    "movies/:id" : "show"
    "movies/:id/edit" : "edit"

  initialize: ->
    console.log "MoviesApp router initialized"

  show: (id) ->
    console.log "movies router show #{id}"
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @show_view = new MoviesApp.Show(movie: movie)
        $(".js-content").html @show_view.render().el

  edit: (id) ->
    console.log "movies router edit #{id}"
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        movie = movie.get("movie")

        @edit_alternative_titles_view = new MoviesApp.EditAlternativeTitles(alternative_titles: movie.alternative_titles)
        $(".js-content").html @edit_alternative_titles_view.render().el

        @edit_view = new MoviesApp.Edit(movie: movie)
        $(".js-content").append @edit_view.render().el
