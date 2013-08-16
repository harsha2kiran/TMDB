class MoviesApp.RevenueCountry extends Backbone.Model
  urlRoot: "/api/v1/revenue_countries"
  initialize: (options) ->
    @options = options
