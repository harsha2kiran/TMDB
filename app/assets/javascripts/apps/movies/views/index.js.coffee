class MoviesApp.Index extends Backbone.View
  template: JST['templates/movies/index']
  className: "row-fluid movies-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    movies = @options.movies
    admin = false
    if @options.admin
      admin = true
    my_movie = false
    if @options.my_movie
      my_movie = true
    index.html @template(movies: movies, admin: admin, my_movie: my_movie)
    this

