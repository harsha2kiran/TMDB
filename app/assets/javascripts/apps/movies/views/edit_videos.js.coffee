class MoviesApp.EditVideos extends Backbone.View
  template: JST['templates/videos/edit']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-video-save" : "create"
    "click .js-video-remove" : "destroy"
    "click .js-new-video-check" : "check"
    "click .js-switch-video-tabs" : "tabs"
    "click .js-new-youtube-username-check" : "fetch_username"
    "click .js-new-youtube-search-check" : "fetch_search"
    "click .js-new-youtube-playlist-check" : "fetch_playlist"
    "click .js-add-single-video .js-pick-thumbnail" : "pick_thumbnail"

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
    priority = $(@el).find(".js-new-video-priority").val()
    thumbnail = $(@el).find(".js-new-video-thumbnail").attr("src")
    thumbnail2 = $(@el).find(".js-new-video-thumbnail2").val()
    thumbnail3 = $(@el).find(".js-new-video-thumbnail3").val()
    keywords = []
    $.each $(self.el).find(".keyword"), (i, item) ->
      keywords.push $(item).attr("data-id")
    tags = []
    $.each $(self.el).find(".tag"), (i, item) ->
      tags.push [$(item).attr("data-id"), $(item).attr("data-type")]

    if link != "" && priority != "" && title != "" && thumbnail != ""
      if link.indexOf("http") < 0
        link = "http://" + link
      if link.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/)
        if !isNaN(priority)
          if window.movie_id
            videable_id = window.movie_id
            videable_type = "Movie"
          else if window.person_id
            videable_id = window.person_id
            videable_type = "Person"
          video = new MoviesApp.Video()
          video.url = api_version + "videos?temp_user_id=" + localStorage.temp_user_id
          video.save ({ video: { title: title, description: description, comments: comments, link: link, category: category, priority: priority, videable_type: videable_type, videable_id: videable_id, thumbnail: thumbnail, thumbnail2: thumbnail2, thumbnail3: thumbnail3, link_active: true, temp_user_id: localStorage.temp_user_id }, keywords: keywords, tags: tags }),
            success: ->
              if window.list_id
                self.add_video_to_list(video.id)
              self.reload_items()
              $(".notifications").html("Video added. It will be active after moderation.").show().fadeOut(window.hide_delay)
            error: ->
              console.log "error"
              $(".notifications").html("This video already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
              $(self.el).find(".js-new-video-title").val("").removeClass("error")
              $(self.el).find(".js-new-video-description").val("").removeClass("error")
              $(self.el).find(".js-new-video-link").val("").removeClass("error")
              $(self.el).find(".js-new-video-type").val("").removeClass("error")
              $(self.el).find(".js-new-video-priority").val("").removeClass("error")
              $(self.el).find(".video-info").hide()
        else
          $(@el).find(".video-info input").each (i, input) ->
            $(input).removeClass("error")
          $(self.el).find(".js-new-video-priority").addClass("error")
      else
        $(@el).find(".video-info input").each (i, input) ->
          $(input).removeClass("error")
        $(self.el).find(".js-new-video-link").addClass("error")
    else
      $(@el).find(".video-info input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  reload_items: ->
    console.log "reload_items"
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
          $self.find(".js-new-video-title").val(data.title)
          $self.find(".js-new-video-thumbnail").attr("src", data.thumbnail).removeClass("hide").show()
          $self.find(".js-thumbnail-preview2").attr("src", data.thumbnail2)
          $self.find(".js-thumbnail-preview3").attr("src", data.thumbnail3)
          $self.find(".js-new-video-thumbnail2").val(data.thumbnail2)
          $self.find(".js-new-video-thumbnail3").val(data.thumbnail3)
          $self.find(".js-new-video-link").removeClass("error")
          $self.find(".video-info").removeClass("hide").show()
          @single_video_keywords = new MoviesApp.SingleVideoKeywords()
          $(".single-video-keywords").html @single_video_keywords.render().el
          @single_video_tags = new MoviesApp.SingleVideoTags()
          $(".single-video-tags").html @single_video_tags.render().el
    else
      $self.find(".js-new-video-link").addClass("error")

  add_video_to_list: (id) ->
    console.log "add_video_to_list"
    self = @
    if window.list_id
      listable_id = id
      listable_type = "Video"
      list_item = new MoviesApp.ListItem()
      list_item.url = api_version + "list_items?temp_user_id=" + localStorage.temp_user_id
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          self.reload_list()

  reload_list: ->
    console.log "reload_list"
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list").list_type == "channel"
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el
          $(".video-info").addClass "hide"
          $(".js-new-video-link").val ""

  tabs: (e) ->
    id = $(e.target).attr("id")
    $(".js-video-tabs").addClass "hide"
    $(".#{id}").removeClass "hide"

  fetch_username: (e) ->
    console.log "fetch_username"
    $username = $(@el).find(".js-new-youtube-username")
    username = $.trim($username.val())
    if username.indexOf("/user/") > -1
      username = username.split("/")
      username = username[username.length - 1]
    self = @
    $(e.target).val("Please wait").attr({ "disabled" : "disabled" })
    if username != ""
      $.ajax api_version + "videos/fetch_username",
        method: "POST"
        data:
          username: username
        success: (videos) ->
          videos = videos.videos
          @import_videos_view = new MoviesApp.ImportVideos(videos: videos)
          $(".js-import-videos-list").html @import_videos_view.render().el
          $(e.target).val("Fetch").removeAttr("disabled")

  fetch_search: (e) ->
    console.log "fetch_search"
    $search = $(@el).find(".js-new-youtube-search")
    search = $.trim($search.val())
    self = @
    $(e.target).val("Please wait").attr({ "disabled" : "disabled" })
    if search != ""
      $.ajax api_version + "videos/fetch_search",
        method: "POST"
        data:
          search: search
        success: (videos) ->
          videos = videos.videos.videos
          @import_videos_view = new MoviesApp.ImportVideos(videos: videos)
          $(".js-import-videos-list").html @import_videos_view.render().el
          $(e.target).val("Fetch").removeAttr("disabled")

  fetch_playlist: (e) ->
    console.log "fetch_playlist"
    $playlist = $(@el).find(".js-new-youtube-playlist")
    playlist = $.trim($playlist.val())
    if playlist.indexOf("list=") > -1
      playlist = window.get_url_param(playlist, "list")
    self = @
    $(e.target).val("Please wait").attr({ "disabled" : "disabled" })
    if playlist != ""
      $.ajax api_version + "videos/fetch_playlist",
        method: "POST"
        data:
          playlist: playlist
        success: (videos) ->
          videos = videos.videos
          @import_videos_view = new MoviesApp.ImportVideos(videos: videos)
          $(".js-import-videos-list").html @import_videos_view.render().el
          $(e.target).val("Fetch").removeAttr("disabled")

  pick_thumbnail: (e) ->
    console.log "pick_thumbnail"
    id = $(e.target).attr("data-id")
    current_thumb = $(".js-new-video-thumbnail").attr("src")
    picked_thumb = $(".js-new-video-thumbnail#{id}").val()
    $(".js-new-video-thumbnail").attr({ "src" : picked_thumb })
    $(".js-new-video-thumbnail#{id}").val(current_thumb)
    $(".js-thumbnail-preview#{id}").attr({ "src" : current_thumb })



