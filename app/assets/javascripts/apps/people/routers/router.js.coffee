class PeopleApp.Router extends Backbone.Router

  routes:
    "!/people" : "index"
    "!/my_people" : "my_people"
    "!/people/new" : "new"
    "!/people/:id/my_person" : "my_person"
    "!/people/:id" : "show"
    "!/people/:id/edit/my_person" : "edit_my_person"
    "!/people/:id/edit" : "edit"

  initialize: ->
    @clear_values()
    console.log "PeopleApp router initialized"

  show: (id) ->
    @show_person_action(id, "show")

  my_person: (id) ->
    @show_person_action(id, "my_person")

  show_person_action: (id, my_person) ->
    console.log "people router show #{id}"
    @clear_values()
    window.person_id = id
    person = new PeopleApp.Person()
    if my_person == "my_person"
      person.url = "/api/v1/people/#{id}/my_person"
    else
      person.url = "/api/v1/people/#{id}"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        if person.get("person")
          @show_view = new PeopleApp.Show(person: person, my_person: my_person)
          $(".js-content").html @show_view.render().el

          if current_user
            @add_to_list_view = new MoviesApp.AddToList()
            $(".add-to-list").html @add_to_list_view.render().el

          type = "Person"
          id = window.person_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type, temp_user_id: localStorage.temp_user_id } }),
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
        @index_view = new PeopleApp.Index(people: people, my_person: true)
        $(".js-content").html @index_view.render().el
        if people.models.length < 40
          $(".js-load-more").remove()

  index: ->
    console.log "people index"
    @clear_values()
    people = new PeopleApp.People()
    people.fetch
      success: ->
        @index_view = new PeopleApp.Index(people: people)
        $(".js-content").html @index_view.render().el
        if people.models.length < 40
          $(".js-load-more").remove()

  edit: (id) ->
    @edit_person_action(id, "edit")

  edit_my_person: (id) ->
    @edit_person_action(id, "my_person")

  edit_person_action: (id, my_person) ->
    @clear_values()
    console.log "people router edit #{id}"
    window.person_id = id
    person = new PeopleApp.Person()
    if my_person == "my_person"
      person.url = "/api/v1/people/#{id}/my_person"
    else
      person.url = "/api/v1/people/#{id}"
    person.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        person = person.get("person")

        @edit_view = new PeopleApp.Edit(person: person, my_person: my_person)
        $(".js-content").html @edit_view.render().el

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  new: ->
    console.log "add new person"
    @clear_values()
    @new_view = new PeopleApp.New()
    $(".js-content").html @new_view.render().el

  clear_values: ->
    window.current_page = 1
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
