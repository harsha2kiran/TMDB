window.MoviesApp = {
  initialize: ->
    console.log "Movies app initialized"
    window.MoviesApp.router = new MoviesApp.Router()
}

