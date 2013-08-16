class MoviesApp.Edit extends Backbone.View
  template: JST['templates/movies/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    edit = $(@el)
    movie = @options.movie.get("movie")
    edit.html @template(movie: movie)
    this
