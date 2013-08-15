class DashboardApp.Gallery extends Backbone.View
  template: JST['templates/dashboard/gallery']
  className: "dashboard-gallery"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    gallery = $(@el)
    gallery.html @template(gallery: @collection)
    self = @

    $(@el).find("#mycarousel").jcarousel
      auto: 2
      wrap: "last"
      initCallback: self.mycarousel_initCallback
    this

  mycarousel_initCallback: (carousel) ->
    # Disable autoscrolling if the user clicks the prev or next button.
    carousel.buttonNext.bind "click", ->
      carousel.startAuto 0
    carousel.buttonPrev.bind "click", ->
      carousel.startAuto 0
    # Pause autoscrolling if the user moves with the cursor over the clip.
    carousel.clip.hover (->
      carousel.stopAuto()
    ), ->
      carousel.startAuto()
