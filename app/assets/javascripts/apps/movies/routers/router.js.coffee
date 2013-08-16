class MoviesApp.Router extends Backbone.Router

  routes:
    "movies/:id" : "show"
    "movies/:id/edit" : "edit"

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

  edit: (id) ->
    console.log "movies router edit #{id}"
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @edit_view = new MoviesApp.Edit(movie: movie)
        $(".js-content").html @edit_view.render().el
