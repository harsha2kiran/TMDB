window.MoviesApp = {
  initialize: ->
    window.MoviesApp.router = new MoviesApp.Router()
    window.current_page = 1
    Backbone.history.start()

    $("body").on "click", ".lock", (e) ->
      self = $(@)
      field = $(@).attr("data-field")
      action = $(@).attr("data-action")
      item_id = 0
      item_type = ""
      if window.movie_id
        item_id = window.movie_id
        item_type = "Movie"
      else if window.person_id
        item_id = window.person_id
        item_type = "Person"

      if item_type != "" && item_id != ""
        lock = new MoviesApp.Lock()
        lock.url = api_version + "locks/" + action
        lock.save ({ field: field, item_id: item_id, item_type: item_type, temp_user_id: localStorage.temp_user_id }),
          success: (data) ->
            if action == "mark"
              self.prev().attr("readonly", "readonly")
              self.attr("data-action", "unmark")
              self.html "Unlock"
            else
              self.prev().removeAttr("readonly")
              self.attr("data-action", "mark")
              self.html "Lock"
      else
        alert "error"

  # "global" methods

  add_keywords_to_media: (media_id, media_type, container, reload) ->
    self = @
    console.log "add keywords to media"
    keyword_ids = []
    if container.find(".keyword").length > 0
      container.find(".keyword").each ->
        keyword_ids.push parseInt($(@).attr("data-id"))
      media_keyword = new MoviesApp.MediaKeyword()
      media_keyword.save ({ keyword_ids: keyword_ids, mediable_id: media_id, mediable_type: media_type, temp_user_id: localStorage.temp_user_id }),
        success: ->
          if keyword_ids.length == 1
            $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          else
            $(".notifications").html("Keywords added. They will be active after moderation.").show().fadeOut(window.hide_delay)
          if reload
            self.reload_media(media_id, media_type)

  add_tags_to_media: (media_id, media_type, container, reload) ->
    console.log "add tags to media"
    self = @
    tag_types = []
    tag_ids = []
    tags_list = container.find(".tag")
    if tags_list.length > 0
      tags_list.each ->
        tag_types.push $(@).attr("data-type")
        tag_ids.push parseInt($(@).attr("data-id"))
      media_tag = new MoviesApp.MediaTag()
      media_tag.save ({ tag_types: tag_types, tag_ids: tag_ids, mediable_id: media_id, mediable_type: media_type, temp_user_id: localStorage.temp_user_id }),
        success: ->
          if tag_ids.length == 1
            $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          else
            $(".notifications").html("Tags added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          if reload
            self.reload_media(media_id, media_type)

  reload_media: (media_id, media_type) ->
    if media_type == "Image"
      item = new MoviesApp.Image()
      item.url = "/api/v1/images/#{media_id}"
      item.fetch
        success: ->
          if item.get("image")
            item = item.get("image")
            @tags_view = new MoviesApp.SingleImageTags(item: item)
            $(".single-image-tags").html @tags_view.render().el
            @keywords_view = new MoviesApp.SingleImageKeywords(item: item)
            $(".single-image-keywords").html @keywords_view.render().el

}


