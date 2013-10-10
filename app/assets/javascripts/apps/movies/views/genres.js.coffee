class MoviesApp.GenresIndex extends Backbone.View
  template: JST['templates/movies/index']
  className: "row movies-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    movies = @options.movies
    index.html @template(movies: movies)
    this

