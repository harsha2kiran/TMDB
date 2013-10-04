class MoviesApp.EditSingleImage extends Backbone.View
  template: JST['templates/images/edit_single_image']
  className: "row-fluid edit-single-image"

  events:
    "click .js-drop-image-update" : "update"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    edit = $(@el)
    console.log @container
    @image = @options.image
    edit.html @template(image: @image)
    this

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parent()
    title = $(@el).find(".js-drop-image-title").val()
    description = $(@el).find(".js-drop-image-description").val()
    if title != "" && window.list_id
      image = new MoviesApp.Image()
      imageable_id = window.list_id
      imageable_type = "List"
      image.save ({ id: @image.id, image: { id: @image.id, description: description, title: title, imageable_id: imageable_id, imageable_type: imageable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          if window.list_id
            self.add_image_to_list(self.image_id)
          $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(container).remove()
          self.reload_list_items()
    else
      $(@el).find(".js-new-image-title").addClass("error").focus()

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

  # reload_items: ->
  #   if window.movie_id
  #     movie = new MoviesApp.Movie()
  #     movie.url = api_version + "movies/#{window.movie_id}/my_movie"
  #     movie.fetch
  #       data:
  #         temp_user_id: localStorage.temp_user_id
  #       success: =>
  #         movie = movie.get("movie")
  #         $(@el).remove()
  #         @stopListening()
  #         @edit_images_view = new MoviesApp.EditImages(images: movie.images)
  #         $(".images").html @edit_images_view.render().el
  #   else if window.person_id
  #     person = new PeopleApp.Person()
  #     person.url = api_version + "people/#{window.person_id}/my_person"
  #     person.fetch
  #       data:
  #         temp_user_id: localStorage.temp_user_id
  #       success: =>
  #         person = person.get("person")
  #         $(@el).remove()
  #         @stopListening()
  #         @edit_images_view = new MoviesApp.EditImages(images: person.images)
  #         $(".images").html @edit_images_view.render().el

  # destroy: (e) ->
  #   container = $(e.target).parents(".image").first()
  #   id = $(e.target).attr("data-id")
  #   $.ajax api_version + "images/" + id,
  #     method: "DELETE"
  #     success: =>
  #       container.remove()
  #       $(".notifications").html("Image removed.").show().fadeOut(window.hide_delay)


  #       if list.get("list").list_type == "gallery"
  #         @edit_images_view = new MoviesApp.EditImages(images: [], gallery: true)
  #         $(".add-images-form").append @edit_images_view.render().el

  #       $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })
