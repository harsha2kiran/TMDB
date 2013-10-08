class MoviesApp.RelatedImages extends Backbone.View
  template: JST['templates/images/related_images']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    images = @options.images
    show.html @template(images: images)
    this
