class MoviesApp.FollowsIndex extends Backbone.View
  template: JST['templates/follows/index']
  className: "row-fluid follows-index"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .unfollow" : "unfollow"

  render: ->
    index = $(@el)
    follows = @options.follows
    index.html @template(follows: follows)
    this

  unfollow: (e) ->
    $self = $(e.target)
    id = $(e.target).attr("data-id")
    $.ajax api_version + "follows/" + id,
      method: "DELETE"
      success: =>
        $self.parents(".follow").first().remove()

