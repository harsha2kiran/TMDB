class PeopleApp.Router extends Backbone.Router

  routes:
    "people/:id" : "show"

  initialize: ->
    console.log "PeopleApp router initialized"

  show: (id) ->
    console.log "people router show #{id}"
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{id}"
    person.fetch
      success: ->
        @show_view = new PeopleApp.Show(person: person)
        $(".js-content").html @show_view.render().el
