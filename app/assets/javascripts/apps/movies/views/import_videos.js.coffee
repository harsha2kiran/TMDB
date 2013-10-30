class MoviesApp.ImportVideos extends Backbone.View
  template: JST['templates/videos/import_videos']
  className: "row import-videos"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-import" : "import"
    "click .js-import-all" : "import_all"

  render: ->
    self = @
    @container = $(@el)
    videos = @options.videos
    @container.html @template(videos: videos)
    this

  import: (e) ->
    self = @
    console.log "import"
    parent = $(e.target).parents(".import-video")
    self.insert_video(self, parent)

  insert_video: (self, parent) ->
    title = parent.find(".js-title").val()
    description = parent.find(".js-description").val()
    quality = parent.find(".js-quality").val()
    priority = parent.find(".js-priority").val()
    duration = parent.find(".js-duration").val()
    link = parent.find(".js-link").val()
    thumbnail = parent.find("img").attr("src")

    videable_id = window.list_id
    videable_type = "List"

    if link != "" && description != "" && priority != "" && title != "" && duration != "" && thumbnail != ""
      if link.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/)
        if !isNaN(priority)
          video = new MoviesApp.Video()
          video.save ({ video: { title: title, description: description, duration: duration, link: link, quality: quality, priority: priority, videable_type: videable_type, videable_id: videable_id, thumbnail: thumbnail, link_active: true, temp_user_id: localStorage.temp_user_id } }),
            success: ->
              if window.list_id
                self.add_video_to_list(video.id)
              $(".notifications").html("Video added. It will be active after moderation.").show().fadeOut(window.hide_delay)
              parent.remove()
              self.reload_list_items()
              $(parent).find("input, textarea").each (i, input) ->
                $(input).removeClass("error")
            error: ->
              console.log "error"
              $(".notifications").html("This video already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
              $(parent).remove()
        else
          self.validate(parent)
          $(parent).find(".js-priority").addClass "error"
      else
        self.validate(parent)
    else
      self.validate(parent)

  validate: (parent) ->
    $(parent).find("input, textarea").each (i, input) ->
      if $.trim($(input).val()) == ""
        $(input).addClass("error")
      else
        $(input).removeClass("error")

  import_all: (e) ->
    console.log "import_all"
    self = @
    parents = $(".import-video")
    parents.each (i, parent) ->
      self.insert_video(self, $(parent))

  add_video_to_list: (video_id) ->
    self = @
    if window.list_id
      listable_id = video_id
      listable_type = "Video"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)

  reload_list_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el
