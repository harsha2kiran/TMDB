class AdminApp.MainItemsIndex extends Backbone.View
  template: JST['templates/admin/main_items_index']
  className: "row-fluid main-items-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    items = @options.items
    type = @options.type
    index.html @template(items: items, type: type)
    this

