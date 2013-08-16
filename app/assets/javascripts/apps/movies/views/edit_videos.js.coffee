class MoviesApp.EditVideos extends Backbone.View
  template: JST['templates/videos/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-video-save" : "create"
    "click .js-video-remove" : "destroy"

  render: ->
    edit = $(@el)
    videos = @options.videos
    edit.html @template(videos: videos)
    this

  create: (e) ->
    console.log "create"
    self = @
    link = $(@el).find(".js-new-video-link").val()
    video_type = $(@el).find(".js-new-video-type").val()
    quality = $(@el).find(".js-new-video-quality").val()
    priority = $(@el).find(".js-new-video-priority").val()
    video = new MoviesApp.Video()
    video.save ({ video: { link: link, video_type: video_type, quality: quality, priority: priority, videable_type: "Movie", videable_id: movie_id } }),
      success: ->
        $(".notifications").html("Video added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-video-link").val("")
        $(self.el).find(".js-new-video-type").val("")
        $(self.el).find(".js-new-video-quality").val("")
        $(self.el).find(".js-new-video-priority").val("")

  destroy: (e) ->
    container = $(e.target).parents(".video").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "videos/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Video removed.").show().fadeOut(10000)
