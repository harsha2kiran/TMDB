class AdminApp.Movie extends Backbone.View
  template: JST['templates/admin/movie']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    movie = @options.movie.get("movie")
    show.html @template(movie: movie)
    this
