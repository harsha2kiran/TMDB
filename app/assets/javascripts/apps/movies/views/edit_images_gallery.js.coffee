class MoviesApp.EditImagesGallery extends Backbone.View
  template: JST['templates/images/edit_gallery']
  className: "row-fluid edit-images-gallery"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-image-update" : "update"
    "click .js-image-remove" : "destroy"
    "drop .drop-image" : "test"
    "dragover .drop-image" : "test"
    "click .dropped-save-all" : "save_all_dropped"

  test: ->
    console.log "Test"

  render: ->
    edit = $(@el)
    @edit = $(@el)
    images = @options.images
    gallery = true
    edit.html @template(images: images, gallery: gallery)
    self = @
    self.image_id = 0
    $(@el).find(".js-new-image-form").fileupload
      add: (e, data) ->
        console.log "add"
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
        if data.result.title && data.result.title != "" && window.list_id
          self.add_image_to_list(data.result.id)
          $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_list_items()
          $(".js-new-image-title").removeClass("error").val("")
          $(".js-new-image-description").removeClass("error").val("")
        else
          @edit_single_image_view = new MoviesApp.EditSingleImage(image: data.result)
          $(".dropped-images").append @edit_single_image_view.render().el
          $(".div-dropped-save-all").remove()
          if $(".dropped-image").length > 1
            $(".dropped-images").append "<div class='div-dropped-save-all span12 text-center'><input type='button' value='Save all' class='dropped-save-all' /></div>"
        $(".js-upload-status").html("Finished uploading image.")
        console.log('done')
    this

  update: (e) ->
    console.log "update"
    self = @
    is_main_image = $(@el).find(".js-new-image-main").val()
    title = $(@el).find(".js-new-image-title").val()
    description = $(@el).find(".js-new-image-description").val()
    if title != "" && window.list_id
      image = new MoviesApp.Image()
      imageable_id = window.list_id
      imageable_type = "List"
      image.save ({ id: @image_id, image: { id: @image_id, description: description, title: title, imageable_id: imageable_id, imageable_type: imageable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          if window.list_id
            self.add_image_to_list(self.image_id)
          $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-title").removeClass("error").val("")
          $(self.el).find(".js-new-image-description").removeClass("error").val("")
          self.reload_items()
    else
      $(@el).find(".js-new-image-title").addClass("error").focus()

  reload_list_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el

  reload_items: ->
    if window.movie_id
      movie = new MoviesApp.Movie()
      movie.url = api_version + "movies/#{window.movie_id}/my_movie"
      movie.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          movie = movie.get("movie")
          $(@el).remove()
          @stopListening()
          @edit_images_view = new MoviesApp.EditImages(images: movie.images)
          $(".images").html @edit_images_view.render().el
    else if window.person_id
      person = new PeopleApp.Person()
      person.url = api_version + "people/#{window.person_id}/my_person"
      person.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          person = person.get("person")
          $(@el).remove()
          @stopListening()
          @edit_images_view = new MoviesApp.EditImages(images: person.images)
          $(".images").html @edit_images_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".image").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "images/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Image removed.").show().fadeOut(window.hide_delay)

  add_image_to_list: (image_id) ->
    self = @
    if window.list_id
      listable_id = image_id
      listable_type = "Image"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)

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

  save_all_dropped: ->
    $(".dropped-image").each ->
      container = $(@)
      update = container.find(".js-drop-image-update")
      update.click()
    $(".div-dropped-save-all").remove()

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-image-keyword").val()
    if value != ""
      model = new MoviesApp.Keyword()
      model.save ({ keyword: { keyword: value } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val(value).removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Keyword is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-image-keyword").addClass("error")

  create: (e) ->
    self = @
    keyword_id = $(@el).find(".js-new-image-keyword-id").val()
    last_image_id = 0
    if keyword_id != ""
      media_keyword = new MoviesApp.MediaKeyword()
      media_keyword.save ({ media_keyword: { keyword_id: keyword_id, mediable_id: last_image_id, mediable_type: "Image", temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Keyword already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val("")
    else
      $(@el).find(".js-new-image-keyword").addClass("error").focus()

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()

