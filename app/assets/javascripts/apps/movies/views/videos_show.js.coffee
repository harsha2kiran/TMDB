class MoviesApp.VideosShow extends Backbone.View
  template: JST['templates/videos/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    video = @options.video.get("video")
    show.html @template(video: video)
    this
