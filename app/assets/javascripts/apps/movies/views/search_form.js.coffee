class MoviesApp.SearchForm extends Backbone.View
  template: JST['templates/search_form']

  events:
    "click .test" : "test"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    search_form = $(@el)
    search_form.html @template
    this

  test: ->
    console.log "click"
