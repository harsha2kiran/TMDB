class PeopleApp.AlternativeName extends Backbone.Model
  urlRoot: "/api/v1/alternative_names"
  initialize: (options) ->
    @options = options
