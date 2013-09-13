class PeopleApp.Router extends Backbone.Router

  routes:
    "people" : "index"
    "my_people" : "my_people"
    "people/new" : "new"
    "people/:id" : "show"
    "people/:id/edit" : "edit"

  initialize: ->
    @clear_values()
    console.log "PeopleApp router initialized"

  show: (id) ->
    console.log "people router show #{id}"
    @clear_values()
    window.person_id = id
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{id}"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        if person.get("person")
          @show_view = new PeopleApp.Show(person: person)
          $(".js-content").html @show_view.render().el

          type = "Person"
          id = window.person_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type } }),
            success: ->
              console.log view

          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })
        else
          @show_view = new MoviesApp.NotFound(type: "person")
          $(".js-content").html @show_view.render().el

  my_people: ->
    console.log "my movies"
    @clear_values()
    people = new PeopleApp.People()
    people.url = api_version + "people/my_people"
    people.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        @index_view = new PeopleApp.Index(people: people)
        $(".js-content").html @index_view.render().el

  index: ->
    console.log "people index"
    @clear_values()
    people = new PeopleApp.People()
    people.fetch
      success: ->
        @index_view = new PeopleApp.Index(people: people)
        $(".js-content").html @index_view.render().el

  edit: (id) ->
    @clear_values()
    console.log "people router edit #{id}"
    window.person_id = id
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{id}"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        person = person.get("person")

        @edit_view = new PeopleApp.Edit(person: person)
        $(".js-content").html @edit_view.render().el

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  new: ->
    console.log "add new person"
    @clear_values()
    @new_view = new PeopleApp.New()
    $(".js-content").html @new_view.render().el

  clear_values: ->
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    try
      delete window.list_id
    catch e
      window.list_id = undefined
