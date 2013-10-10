class MoviesApp.NotFound extends Backbone.View
  template: JST['templates/movies/not_found']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    page = $(@el)
    @template = switch
      when @options.type == "person" then JST["templates/people/not_found"]
      when @options.type == "movie" then JST["templates/movies/not_found"]
      when @options.type == "image" then JST["templates/images/not_found"]
      when @options.type == "video" then JST["templates/videos/not_found"]
      when @options.type == "list" then JST["templates/lists/not_found"]
      when @options.type == "genre" then JST["templates/genres/not_found"]
    page.html @template
    this
