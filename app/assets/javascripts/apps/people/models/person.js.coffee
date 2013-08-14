class PeopleApp.Person extends Backbone.Model
  urlRoot: "/api/v1/people"
  initialize: (options) ->
    @options = options
