class MoviesApp.VideosShow extends Backbone.View
  template: JST['templates/videos/show']
  className: "row videos-show"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-video-update" : "update"
    "click .js-video-update-main" : "update_main"

  render: ->
    self = @
    container = $(@el)
    @container = $(@el)

    @video = @options.video.get("video")
    container.html @template(video: @video)

    @keywords_view = new MoviesApp.SingleVideoKeywords(item: @video)
    container.find(".single-video-keywords").html @keywords_view.render().el

    @tags_view = new MoviesApp.SingleVideoTags(item: @video)
    container.find(".single-video-tags").html @tags_view.render().el

    this

  update_main: (e) ->
    console.log "update_main"
    id = window.video_id
    self = @
    parent = $(self.el)
    title = parent.find(".js-video-title").val()
    description = parent.find(".js-video-description").val()
    if title != ""
      parent.find(".js-video-title").removeClass("error")
      video = new MoviesApp.Video()
      video.url = api_version + "videos/" + id
      video.set( id: id, video: { title: title, description: description, id: id })
      video.save null,
        success: ->
          $(".notifications").html("Successfully updated.").show().fadeOut(window.hide_delay)
    else
      parent.find(".js-video-title").addClass("error")

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parents(".videos-show").first()
    MoviesApp.add_keywords_to_media(window.video_id, "Video", $(self.el), true)
    MoviesApp.add_tags_to_media(window.video_id, "Video", $(self.el), true)
    $(".notifications").html("Successfully updated keywords and tags. They will be active after moderation.").show().fadeOut(window.hide_delay)
