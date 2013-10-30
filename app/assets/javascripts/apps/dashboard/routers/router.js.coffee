class DashboardApp.Router extends Backbone.Router

  routes:
    "" : "index"
    "!/dashboard/edit_popular" : "edit_popular"

  initialize: ->

  index: ->
    unless window.skip
      window.skip = false
      console.log "router index"
      @search_form = new DashboardApp.SearchForm()
      $(".js-content").html @search_form.render().el

      # @menu = new DashboardApp.Menu()
      # $(".js-content").append @menu.render().el

      gallery = new DashboardApp.GalleryCollection()
      gallery.fetch
        success: ->
          @gallery = new DashboardApp.Gallery(collection: gallery)
          $(".js-content").append @gallery.render().el

  edit_popular: ->
    console.log "edit pop"
    if current_user && current_user.user_type == "admin"
      self = @
      gallery = new DashboardApp.GalleryCollection()
      gallery.url = "/api/v1/movies/edit_popular"
      gallery.fetch
        success: ->
          @edit_gallery = new DashboardApp.EditGallery(collection: gallery)
          $(".js-content").html @edit_gallery.render().el

