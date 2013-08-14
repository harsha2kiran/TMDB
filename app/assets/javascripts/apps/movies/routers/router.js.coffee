class MoviesApp.Router extends Backbone.Router

  routes:
    "movies/:id" : "show"

  initialize: ->
    console.log "MoviesApp router initialized"

  show: (id) ->
    console.log "movies router show #{id}"
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @show_view = new MoviesApp.Show(movie: movie)
        $(".js-content").html @show_view.render().el
