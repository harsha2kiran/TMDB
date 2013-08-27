class AdminApp.Person extends Backbone.View
  template: JST['templates/admin/person']

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    person = @options.person.get("person")
    show.html @template(person: person)
    this

