class MoviesApp.ImagesShow extends Backbone.View
  template: JST['templates/images/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    image = @options.image.get("image")
    show.html @template(image: image)
    this

