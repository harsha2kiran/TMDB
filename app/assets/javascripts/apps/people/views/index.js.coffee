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
    index.html @template(people: people, admin: admin)
    this

