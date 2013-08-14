window.PeopleApp = {
  initialize: ->
    console.log "People app initialized"
    window.PeopleApp.router = new PeopleApp.Router()
}

