class MoviesApp.ListsIndex extends Backbone.View
  template: JST['templates/lists/index']
  className: "row-fluid lists-index"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"

  render: ->
    index = $(@el)
    lists = @options.lists
    index.html @template(lists: lists)
    this

  destroy: (e) ->
    id = $(@el).find(".js-remove input").val()
    console.log id
