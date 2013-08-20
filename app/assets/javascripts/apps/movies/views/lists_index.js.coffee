class MoviesApp.ListsIndex extends Backbone.View
  template: JST['templates/lists/index']
  className: "row-fluid lists-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    lists = @options.lists
    index.html @template(lists: lists)
    this

