class AdminApp.ItemsIndex extends Backbone.View
  template: JST['templates/admin/items_index']
  className: "row-fluid items-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    items = @options.items
    type = @options.type
    index.html @template(items: items, type: type)
    this

