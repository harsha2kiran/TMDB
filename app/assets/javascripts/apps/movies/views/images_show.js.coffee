class MoviesApp.ImagesShow extends Backbone.View
  template: JST['templates/images/show']
  className: "row images-show"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-image-update" : "update"
    "click .js-image-update-main" : "update_main"

  render: ->
    self = @
    container = $(@el)
    @container = $(@el)

    @image = @options.image.get("image")
    container.html @template(image: @image)

    @keywords_view = new MoviesApp.SingleImageKeywords(item: @image)
    container.find(".single-image-keywords").html @keywords_view.render().el

    @tags_view = new MoviesApp.SingleImageTags(item: @image)
    container.find(".single-image-tags").html @tags_view.render().el

    this

  update_main: (e) ->
    console.log "update_main"
    id = window.image_id
    self = @
    parent = $(self.el)
    title = parent.find(".js-image-title").val()
    description = parent.find(".js-image-description").val()
    if title != ""
      parent.find(".js-image-title").removeClass("error")
      image = new MoviesApp.Image()
      image.url = api_version + "images/" + id
      image.set( id: id, image: { title: title, description: description, id: id })
      image.save null,
        success: ->
          $(".notifications").html("Successfully updated.").show().fadeOut(window.hide_delay)
    else
      parent.find(".js-image-title").addClass("error")

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parents(".images-show").first()
    MoviesApp.add_keywords_to_media(window.image_id, "Image", $(self.el), true)
    MoviesApp.add_tags_to_media(window.image_id, "Image", $(self.el), true)
    $(".notifications").html("Successfully updated keywords and tags. They will be active after moderation.").show().fadeOut(window.hide_delay)
