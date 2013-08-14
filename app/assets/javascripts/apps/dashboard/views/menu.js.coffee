class DashboardApp.Menu extends Backbone.View
  template: JST['templates/dashboard/menu']
  className: "dashboard-menu"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    menu = $(@el)
    menu.html @template
    this
