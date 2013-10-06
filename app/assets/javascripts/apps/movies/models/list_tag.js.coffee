class MoviesApp.ListTag extends Backbone.Model
  urlRoot: "/api/v1/list_tags"
  initialize: (options) ->
    @options = options
