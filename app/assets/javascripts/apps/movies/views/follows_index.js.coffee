class MoviesApp.FollowsIndex extends Backbone.View
  template: JST['templates/follows/index']
  className: "row follows-index"

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
    followable_id = $(e.target).attr("data-followable_id")
    followable_type = $(e.target).attr("data-followable_type")
    $.ajax api_version + "follows/test",
      method: "DELETE"
      data:
        followable_id: followable_id
        followable_type: followable_type
      success: =>
        $self.parents(".follow").first().remove()

