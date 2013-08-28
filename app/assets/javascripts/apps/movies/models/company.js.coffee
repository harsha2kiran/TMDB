class MoviesApp.Company extends Backbone.Model
  urlRoot: "/api/v1/companies"
  initialize: (options) ->
    @options = options
