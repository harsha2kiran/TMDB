class MoviesApp.GenresIndex extends Backbone.View
  template: JST['templates/genres/index']
  className: "row genres-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    genres = @options.genres
    index.html @template(genres: genres)
    this

