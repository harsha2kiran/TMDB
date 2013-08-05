window.MoviesApp = {
  initialize: ->
    console.log "Dashboard app initialized"
    window.MoviesApp.router = new MoviesApp.Router()
    Backbone.history.start()
}

