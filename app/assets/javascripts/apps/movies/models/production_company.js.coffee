class MoviesApp.ProductionCompany extends Backbone.Model
  urlRoot: "/api/v1/production_companies"
  initialize: (options) ->
    @options = options
