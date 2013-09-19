class AdminApp.Item extends Backbone.Model
  urlRoot: "/api/v1/items"
  initialize: (options) ->
    @options = options
