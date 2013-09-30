class PeopleApp.Index extends Backbone.View
  template: JST['templates/people/index']
  className: "row-fluid people-index"

  events:
    "click .js-load-more" : "load_more"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    people = @options.people
    admin = false
    if @options.admin
      admin = true
    my_person = false
    if @options.my_person
      my_person = true
    index.html @template(people: people, admin: admin, my_person: my_person)
    this

  load_more: ->
    window.current_page = window.current_page + 1

    people = new PeopleApp.People()
    people.fetch
      data:
        page: window.current_page
      success: ->
        $(".js-load-more").remove()
        @index_view = new PeopleApp.Index(people: people)
        $(".js-content").append @index_view.render().el
        if people.models.length < 40
          $(".js-load-more").remove()
