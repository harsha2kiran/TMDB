class MoviesApp.ListItemsShow extends Backbone.View
  template: JST['templates/list_items/show']
  className: "row list-items-show"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"
    "click .js-approve" : "approve"
    "click .js-edit-gallery-image-update" : "image_update"
    "click .js-edit-gallery-video-update" : "video_update"

  render: ->
    show = $(@el)
    list = @options.list
    show.html @template(list: list)
    this

  image_update: (e) ->
    parent = $(e.target).parents(".js-edit-gallery-image").first()
    id = parent.attr("data-id")
    title = parent.find(".js-edit-gallery-image-title").val()
    description = parent.find(".js-edit-gallery-image-description").val()
    priority = parent.find(".js-edit-gallery-image-priority").val()
    if title != ""
      parent.find(".js-edit-gallery-image-title").removeClass("error")
      image = new MoviesApp.Image()
      image.url = api_version + "images/" + id
      image.set({ title: title, description: description, priority: priority, id: id })
      image.save null,
        success: ->
          $(".notifications").html("Successfully updated.").show().fadeOut(window.hide_delay)
    else
      parent.find(".js-edit-gallery-image-title").addClass("error")

  video_update: (e) ->
    parent = $(e.target).parents(".js-edit-gallery-video").first()
    id = parent.attr("data-id")
    title = parent.find(".js-edit-gallery-video-title").val()
    description = parent.find(".js-edit-gallery-video-description").val()
    priority = parent.find(".js-edit-gallery-video-priority").val()
    quality = parent.find(".js-edit-gallery-video-quality").val()
    duration = parent.find(".js-edit-gallery-video-duration").val()
    if title != ""
      parent.find(".js-edit-gallery-video-title").removeClass("error")
      video = new MoviesApp.Video()
      video.url = api_version + "videos/" + id
      video.set({ title: title, description: description, priority: priority, id: id })
      video.save null,
        success: ->
          $(".notifications").html("Successfully updated.").show().fadeOut(window.hide_delay)
    else
      parent.find(".js-edit-gallery-video-title").addClass("error")

  destroy: (e) ->
    if $(e.target).hasClass("js-remove")
      id = $(e.target).find("input").val()
    else
      id = $(e.target).parents(".js-remove").find("input").val()
    container = $(e.target).parents(".item").first()
    $.ajax api_version + "list_items/" + id,
      method: "DELETE"
      data:
        "list_item[list_id]" : window.list_id
        "temp_user_id" : localStorage.temp_user_id
      success: =>
        container.remove()
        $(".notifications").html("Removed from list.").show().fadeOut(window.hide_delay)

  approve: (e) ->
    if $(e.target).hasClass("js-approve")
      id = $(e.target).find("input").val()
    else
      id = $(e.target).parents(".js-approve").find("input").val()
    container = $(e.target).parents(".item").first()

    $.ajax api_version + "list_items/" + id,
      method: "PUT"
      data:
        "list_item[id]" : id
        "list_item[list_id]" : window.list_id
        "list_item[approved]" : true
      success: ->
        $(".notifications").html("Successfully approved list item.").show().fadeOut(window.hide_delay)
        $(e.target).remove()

