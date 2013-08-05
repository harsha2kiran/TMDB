class MoviesApp.Router extends Backbone.Router

  routes:
    "" : "index"

  initialize: ->
    console.log "MoviesApp router initialized"

  index: ->
    console.log "router index"
    @search_form = new MoviesApp.SearchForm()
    $("body").html @search_form.render().el
