class PeopleApp.SocialApp extends Backbone.Model
  urlRoot: "/api/v1/social_apps"
  initialize: (options) ->
    @options = options
