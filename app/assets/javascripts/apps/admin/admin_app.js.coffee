window.AdminApp = {
  initialize: ->
    console.log "Admin app initialized"
    window.AdminApp.router = new AdminApp.Router()
}

