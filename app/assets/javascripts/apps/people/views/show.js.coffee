class PeopleApp.Show extends Backbone.View
  template: JST['templates/people/show']

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    person = @options.person.get("person")
    show.html @template(person: person)
    this
