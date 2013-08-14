class MoviesApp.Router extends Backbone.Router

  routes:
    "movies/" : "index"
    "movies/:id" : "show"

  initialize: ->
    console.log "MoviesApp router initialized"

  index:
    console.log "movies router index"

  show: (id) ->
    console.log "movies router show #{id}"
