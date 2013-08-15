class DashboardApp.GalleryModel extends Backbone.Model
  urlRoot: "/api/v1/movies"
  initialize: (options) ->
    @options = options
