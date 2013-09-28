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
    channel = false
    if @options.channel
      channel = true
    edit.html @template(videos: videos, channel: channel)
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
        if !isNaN(priority)
          if window.movie_id
            videable_id = window.movie_id
            videable_type = "Movie"
          else if window.person_id
            videable_id = window.person_id
            videable_type = "Person"
          video = new MoviesApp.Video()
          video.save ({ video: { title: title, description: description, comments: comments, duration: duration, link: link, category: category, quality: quality, priority: priority, videable_type: videable_type, videable_id: videable_id, thumbnail: thumbnail, link_active: true, temp_user_id: localStorage.temp_user_id } }),
            success: ->
              $(".notifications").html("Video added. It will be active after moderation.").show().fadeOut(window.hide_delay)
              self.reload_items()
              if self.options.channel
                $.ajax api_version + "approvals/mark",
                  method: "post"
                  data:
                    approved_id: video.id
                    type: "Video"
                    mark: true
                  success: ->
                    self.add_video_to_list(video.id)
            error: ->
              console.log "error"
              $(".notifications").html("This video already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
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
          $(self.el).find(".js-new-video-priority").addClass("error")
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

  reload_items: ->
    if window.movie_id
      movie = new MoviesApp.Movie()
      movie.url = "/api/v1/movies/#{window.movie_id}/my_movie"
      movie.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          movie = movie.get("movie")
          $(@el).remove()
          @stopListening()
          @edit_videos_view = new MoviesApp.EditVideos(videos: movie.videos)
          $(".videos").html @edit_videos_view.render().el
    else if window.person_id
      person = new PeopleApp.Person()
      person.url = "/api/v1/people/#{window.person_id}/my_person"
      person.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          person = person.get("person")
          $(@el).remove()
          @stopListening()
          @edit_videos_view = new MoviesApp.EditVideos(videos: person.videos)
          $(".videos").html @edit_videos_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".video").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "videos/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Video removed.").show().fadeOut(window.hide_delay)

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

  add_video_to_list: (id) ->
    self = @
    if window.list_id
      listable_id = id
      listable_type = "Video"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          self.reload_list()

  reload_list: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}"
    list.fetch
      success: ->
        @show_view = new MoviesApp.ListsShow(list: list)
        $(".js-content").html @show_view.render().el

        if list.get("list").list_type == "channel"
          @edit_videos_view = new MoviesApp.EditVideos(videos: [], channel: true)
          $(".add-videos-form").append @edit_videos_view.render().el





