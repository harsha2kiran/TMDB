class MoviesApp.ImagesShow extends Backbone.View
  template: JST['templates/images/show']
  className: "row images-show"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-image-update" : "update"

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

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parents(".images-show").first()
    MoviesApp.add_keywords_to_media(window.image_id, "Image", $(self.el), true)
    MoviesApp.add_tags_to_media(window.image_id, "Image", $(self.el), true)
    $(".notifications").html("Successfully updated keywords and tags. They will be active after moderation.").show().fadeOut(window.hide_delay)
