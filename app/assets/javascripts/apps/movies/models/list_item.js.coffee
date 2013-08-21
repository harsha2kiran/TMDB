class MoviesApp.ListItem extends Backbone.Model
  urlRoot: "/api/v1/list_items"
  initialize: (options) ->
    @options = options
