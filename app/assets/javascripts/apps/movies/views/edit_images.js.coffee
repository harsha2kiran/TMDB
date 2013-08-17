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
    edit.html @template(images: images)
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
    image = new MoviesApp.Image()
    image.save ({ id: @image_id, image: { id: @image_id, title: title, is_main_image: is_main_image, imageable_id: movie_id, imageable_type: "Movie" } }),
      success: ->
        $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-image-title").val("")

  destroy: (e) ->
    container = $(e.target).parents(".image").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "images/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Image removed.").show().fadeOut(10000)
