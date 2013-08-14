class DashboardApp.Router extends Backbone.Router

  routes:
    "" : "index"

  initialize: ->
    console.log "DashboardApp router initialized"

  index: ->
    console.log "router index"
    @search_form = new DashboardApp.SearchForm()
    $(".js-content").html @search_form.render().el
    @menu = new DashboardApp.Menu()
    $(".js-content").append @menu.render().el
