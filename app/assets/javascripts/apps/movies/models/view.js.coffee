class MoviesApp.View extends Backbone.Model
  urlRoot: "/api/v1/views"
  initialize: (options) ->
    @options = options
