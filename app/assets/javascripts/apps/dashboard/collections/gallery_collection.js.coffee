class DashboardApp.GalleryCollection extends Backbone.Collection
  model: DashboardApp.GalleryModel
  url: "/api/v1/movies/get_popular"
