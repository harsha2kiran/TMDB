class PeopleApp.PersonSocialApp extends Backbone.Model
  urlRoot: "/api/v1/person_social_apps"
  initialize: (options) ->
    @options = options
