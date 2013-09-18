class AdminApp.MainItem extends Backbone.Model
  urlRoot: "/api/v1/main_items"
  initialize: (options) ->
    @options = options
