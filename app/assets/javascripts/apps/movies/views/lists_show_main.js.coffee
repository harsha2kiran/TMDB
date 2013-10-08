class MoviesApp.ListsShowMain extends Backbone.View
  template: JST['templates/lists/show_main']

  initialize: ->
    _.bindAll this, "render"


  render: ->
    show = $(@el)
    show.html @template
    this

