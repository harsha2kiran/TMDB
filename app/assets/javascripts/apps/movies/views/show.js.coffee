class MoviesApp.Show extends Backbone.View
  template: JST['templates/movies/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .follow" : "follow"
    "click .following" : "unfollow"
    "click .show-add-item" : "add_item"

  render: ->
    show = $(@el)
    movie = @options.movie.get("movie")
    my_movie = @options.my_movie
    show.html @template(movie: movie, my_movie: my_movie)
    this

  follow: (e) ->
    $self = $(e.target)
    type = "Movie"
    id = window.movie_id
    follow = new MoviesApp.Follow()
    follow.save ({ follow: { followable_id: id, followable_type: type } }),
      success: ->
        $self.addClass("following").removeClass("follow").html("Already following")

  unfollow: (e) ->
    $self = $(e.target)
    type = "Movie"
    id = window.movie_id
    $.ajax api_version + "follows/test",
      method: "DELETE"
      data:
        followable_id: id
        followable_type: type
      success: =>
        $self.addClass("follow").removeClass("following").html("Follow")

  add_item: (e) ->
    id = $(e.target).attr("id")
    tab = id.replace("add-", "")
    localStorage.tab = tab
    window.MoviesApp.router.navigate("#movies/#{window.movie_id}/edit/my_movie", true)
