class DashboardApp.EditGallery extends Backbone.View
  template: JST['templates/dashboard/edit_gallery']
  className: "dashboard-edit-gallery"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-popular-save" : "save_popular"
    "click .js-close-edit-gallery" : "close_edit_popular"

  render: ->
    # DashboardApp.router.navigate("/dashboard/edit_popular", true)
    gallery = $(@el)
    gallery.html @template(gallery: @collection)
    self = @
    this

  save_popular: (e) ->
    $values = $(e.target).parents(".values").first()
    $popular = $values.find(".js-popular")
    popular_val = $popular.val()
    if popular_val && popular_val != "" && !isNaN(popular_val)
      id = $values.find(".js-popular-id").val()
      type = $values.find(".js-popular-id").attr("data-type")
      if id && id != ""
        item = new DashboardApp.GalleryModel()
        if type == "Movie"
          item.url = "/api/v1/movies/#{id}"
          item.save ({ id: id, movie: { id: id, popular: popular_val } }),
            success: ->
              console.log "updated"
        else
          item.url = "/api/v1/people/#{id}"
          item.save ({ id: id, person: { id: id, popular: popular_val } }),
            success: ->
              console.log "updated"
    else
      $popular.addClass("error")

  close_edit_popular: (e) ->
    DashboardApp.router.navigate("/", true)
