class MoviesApp.Follows extends Backbone.Collection
  model: MoviesApp.Follow
  url: "/api/v1/follows"
