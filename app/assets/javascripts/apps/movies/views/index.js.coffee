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
    index.html @template(movies: movies, admin: admin)
    this

