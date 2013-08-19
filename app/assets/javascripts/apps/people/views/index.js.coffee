class PeopleApp.Index extends Backbone.View
  template: JST['templates/people/index']
  className: "row-fluid people-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    people = @options.people
    index.html @template(people: people)
    this

