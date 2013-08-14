class MoviesApp.Show extends Backbone.View
  template: JST['templates/movies/show']

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    movie = @options.movie.get("movie")
    show.html @template(movie: movie)
    this
