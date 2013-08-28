class MoviesApp.EditImages extends Backbone.View
  template: JST['templates/images/edit']
  className: "row-fluid edit-images"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-image-update" : "update"
    "click .js-image-remove" : "destroy"

  render: ->
    edit = $(@el)
    images = @options.images
    gallery = false
    if @options.gallery
      gallery = true
    edit.html @template(images: images, gallery: gallery)
    self = @
    self.image_id = 0
    $(@el).find(".js-new-image-form").fileupload
      add: (e, data) ->
        console.log "add"
        $(".js-new-image-save").attr("disabled", "disabled")
        file = data.files[0]
        file.unique_id = Math.random().toString(36).substr(2,16)
        window.data_data = data
        data.submit()
      progress: (e, data) ->
        $(".js-upload-status").html("Uploading image")
        console.log('progress')
      fail: (e, data) ->
        $(".js-upload-status").html("Error uploading image.")
        console.log('fail')
      done: (e, data) ->
        console.log('done')
        self.image_id = data.result.id
        $(".js-new-image-save").removeAttr("disabled")
        $(".js-upload-status").html("Successfully uploaded image. Make sure you insert title and click save to confirm upload.")
    this

  update: (e) ->
    console.log "update"
    self = @
    is_main_image = $(@el).find(".js-new-image-main").val()
    title = $(@el).find(".js-new-image-title").val()
    priority = $(@el).find(".js-new-image-priority").val()
    if title != ""
      if is_main_image != ""
        image = new MoviesApp.Image()
        if window.movie_id
          imageable_id = window.movie_id
          imageable_type = "Movie"
        else if window.person_id
          imageable_id = window.person_id
          imageable_type = "Person"
        image.save ({ id: @image_id, image: { id: @image_id, priority: priority, title: title, is_main_image: is_main_image, imageable_id: imageable_id, imageable_type: imageable_type } }),
          success: ->
            $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(10000)
            $(self.el).find(".js-new-image-title").val("")
            $(@el).find(".js-new-image-main").removeClass("error")
            $(@el).find(".js-new-image-title").removeClass("error").val("")
            if self.options.gallery
              $.ajax api_version + "approvals/mark",
                method: "post"
                data:
                  approved_id: image.id
                  type: "Image"
                  mark: true
                success: ->
                  self.add_image_to_list(image.id)

      else
        $(@el).find(".js-new-image-main").addClass("error").focus()
        $(@el).find(".js-new-image-title").removeClass("error")
    else
      $(@el).find(".js-new-image-title").addClass("error").focus()


  destroy: (e) ->
    container = $(e.target).parents(".image").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "images/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Image removed.").show().fadeOut(10000)

  add_image_to_list: (image_id) ->
    self = @
    if window.list_id
      listable_id = image_id
      listable_type = "Image"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(10000)
          self.reload_list()

  reload_list: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}"
    list.fetch
      success: ->
        @show_view = new MoviesApp.ListsShow(list: list)
        $(".js-content").html @show_view.render().el

        if list.get("list").list_type == "gallery"
          @edit_images_view = new MoviesApp.EditImages(images: [], gallery: true)
          $(".add-images-form").append @edit_images_view.render().el

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })
