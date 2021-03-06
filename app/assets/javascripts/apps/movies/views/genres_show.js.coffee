class MoviesApp.GenresShow extends Backbone.View
  template: JST['templates/genres/show']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .follow" : "follow"
    "click .following" : "unfollow"

  render: ->
    show = $(@el)
    genre = @options.genre.get("genre")
    show.html @template(genre: genre)
    this

  follow: (e) ->
    $self = $(e.target)
    type = "Genre"
    id = window.genre_id
    follow = new MoviesApp.Follow()
    follow.save ({ follow: { followable_id: id, followable_type: type } }),
      success: ->
        $self.addClass("following").removeClass("follow").html("Already following")

  unfollow: (e) ->
    $self = $(e.target)
    type = "Genre"
    id = window.genre_id
    $.ajax api_version + "follows/test",
      method: "DELETE"
      data:
        followable_id: id
        followable_type: type
      success: =>
        $self.addClass("follow").removeClass("following").html("Follow")
