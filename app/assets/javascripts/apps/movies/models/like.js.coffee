class MoviesApp.Like extends Backbone.Model
  urlRoot: "/api/v1/likes"
  initialize: (options) ->
    @options = options
