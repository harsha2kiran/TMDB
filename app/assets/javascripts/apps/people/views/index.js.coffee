class PeopleApp.Index extends Backbone.View
  template: JST['templates/people/index']
  className: "row-fluid people-index"

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

