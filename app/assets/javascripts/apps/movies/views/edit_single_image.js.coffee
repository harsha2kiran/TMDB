class MoviesApp.EditSingleImage extends Backbone.View
  template: JST['templates/images/edit_single_image']
  className: "row edit-single-image"

  events:
    "click .js-drop-image-update" : "update"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    edit = $(@el)
    @edit = $(@el)
    @image = @options.image
    edit.html @template(image: @image)

    @keywords_view = new MoviesApp.SingleImageKeywords(item: @image)
    edit.find(".single-image-keywords").html @keywords_view.render().el

    @tags_view = new MoviesApp.SingleImageTags(item: @image)
    edit.find(".single-image-tags").html @tags_view.render().el

    this

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parents(".dropped-image").first()
    title = $(container).find(".js-drop-image-title").val()
    description = $(container).find(".js-drop-image-description").val()
    if title != "" && window.list_id
      image = new MoviesApp.Image()
      imageable_id = window.list_id
      imageable_type = "List"
      image.url = api_version + "images/" + @image.id + "?temp_user_id=" + localStorage.temp_user_id
      image.save ({ id: @image.id, image: { id: @image.id, description: description, title: title, imageable_id: imageable_id, imageable_type: imageable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          if window.list_id
            self.add_image_to_list(image.id)
            MoviesApp.add_keywords_to_media(image.id, "Image", $(self.el), false)
            MoviesApp.add_tags_to_media(image.id, "Image", $(self.el), false)
          $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(container).remove()
          self.reload_list_items()
    else
      $(@el).find(".js-drop-image-title").addClass("error").focus()

  add_image_to_list: (image_id) ->
    self = @
    if window.list_id
      listable_id = @image.id
      listable_type = "Image"
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
          if $(".dropped-image").length == 0
            $(".div-dropped-save-all").remove()

