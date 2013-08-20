class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    show = $(@el)
    list = @options.list.get("list")
    show.html @template(list: list)
    this
