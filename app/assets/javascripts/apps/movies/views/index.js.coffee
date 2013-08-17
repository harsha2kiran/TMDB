class MoviesApp.Index extends Backbone.View
  template: JST['templates/movies/index']
  className: "row-fluid movies-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    movies = @options.movies
    index.html @template(movies: movies)
    this

