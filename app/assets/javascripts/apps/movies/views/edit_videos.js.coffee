class MoviesApp.EditVideos extends Backbone.View
  template: JST['templates/videos/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-video-save" : "create"
    "click .js-video-remove" : "destroy"
    "click .js-new-video-check" : "check"

  render: ->
    edit = $(@el)
    videos = @options.videos
    edit.html @template(videos: videos)
    this

  create: (e) ->
    console.log "create"
    self = @
    title = $(@el).find(".js-new-video-title").val()
    link = $(@el).find(".js-new-video-link").val()
    category = $(@el).find(".js-new-video-category").val()
    description = $(@el).find(".js-new-video-description").val()
    comments = $(@el).find(".js-new-video-comments").val()
    duration = $(@el).find(".js-new-video-duration").val()
    quality = $(@el).find(".js-new-video-quality").val()
    priority = $(@el).find(".js-new-video-priority").val()
    thumbnail = $(@el).find(".js-new-video-thumbnail").attr("src")

    if link != "" && category != "" && comments != "" && description != "" && priority != "" && quality != "" && title != "" && duration != "" && thumbnail != ""
      if link.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/)
        if window.movie_id
          videable_id = window.movie_id
          videable_type = "Movie"
        else if window.person_id
          videable_id = window.person_id
          videable_type = "Person"
        video = new MoviesApp.Video()
        video.save ({ video: { title: title, description: description, comments: comments, duration: duration, link: link, category: category, quality: quality, priority: priority, videable_type: videable_type, videable_id: videable_id, thumbnail: thumbnail } }),
          success: ->
            $(".notifications").html("Video added. It will be active after moderation.").show().fadeOut(10000)
            $(self.el).find(".js-new-video-title").val("").removeClass("error")
            $(self.el).find(".js-new-video-description").val("").removeClass("error")
            $(self.el).find(".js-new-video-comments").val("").removeClass("error")
            $(self.el).find(".js-new-video-duration").val("").removeClass("error")
            $(self.el).find(".js-new-video-link").val("").removeClass("error")
            $(self.el).find(".js-new-video-type").val("").removeClass("error")
            $(self.el).find(".js-new-video-quality").val("").removeClass("error")
            $(self.el).find(".js-new-video-priority").val("").removeClass("error")
            $(self.el).find(".js-new-video-category").val("").removeClass("error")
            $(self.el).find(".video-info").hide()
      else
        $(@el).find("input").each (i, input) ->
          $(input).removeClass("error")
        $(self.el).find(".js-new-video-link").addClass("error")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".video").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "videos/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Video removed.").show().fadeOut(10000)

  check: (e) ->
    $self = $(@el)
    s = @
    link = $self.find(".js-new-video-link").val()
    if link != ""
      $.ajax api_version + "videos/check",
        method: "POST"
        data:
          link: link
        success: (data) ->
          duration = s.set_duration(data.duration)
          $self.find(".js-new-video-title").val(data.title)
          $self.find(".js-new-video-description").val(data.description)
          $self.find(".js-new-video-comments").val(data.comments)
          $self.find(".js-new-video-category").val(data.category)
          $self.find(".js-new-video-duration").val(duration)
          $self.find(".js-new-video-thumbnail").attr("src", data.thumbnail).removeClass("hide").show()
          $self.find(".js-new-video-link").removeClass("error")
          $self.find(".video-info").removeClass("hide").show()
    else
      $self.find(".js-new-video-link").addClass("error")

  set_duration: (seconds) ->
    numdays = Math.floor(seconds / 86400)
    numhours = Math.floor((seconds % 86400) / 3600)
    numminutes = Math.floor(((seconds % 86400) % 3600) / 60)
    numseconds = ((seconds % 86400) % 3600) % 60

    if numminutes.toString().length == 1
      numminutes = "0" + numminutes
    if numhours.toString().length == 1
      numhours = "0" + numhours
    if numseconds.toString().length == 1
      numseconds = "0" + numseconds
    s = numhours + ":" + numminutes + ":" + numseconds
    s








