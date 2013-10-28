class MoviesApp.User extends Backbone.Model
  urlRoot: "/api/v1/users"
  initialize: (options) ->
    @options = options
