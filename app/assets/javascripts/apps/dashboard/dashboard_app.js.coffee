window.DashboardApp = {
  initialize: ->
    console.log "Dashboard app initialized"
    window.DashboardApp.router = new DashboardApp.Router()
    Backbone.history.start()
}

