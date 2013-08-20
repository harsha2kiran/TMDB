class MoviesApp.GenresShow extends Backbone.View
  template: JST['templates/genres/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    genre = @options.genre.get("genre")
    show.html @template(genre: genre)
    this
