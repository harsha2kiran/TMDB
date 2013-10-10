class MoviesApp.LikesShow extends Backbone.View
  template: JST['templates/likes/show']
  className: "row likes-show"

  events:
    "click .js-like" : "like_dislike"
    "click .js-dislike" : "like_dislike"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    @container = $(@el)
    @item = @options.item

    likes = @item.likes.length
    dislikes = @item.dislikes.length

    liked = ""
    disliked = ""

    liked = @hide_like(@item.likes)
    disliked = @hide_like(@item.dislikes)

    @container.html @template(likes: likes, dislikes: dislikes, liked: liked, disliked: disliked)
    this

  like_dislike: (e) ->
    console.log "like_dislike"
    if $(e.target).hasClass("js-like")
      status = 1
      @send_request(status)
    else
      status = 0
      @send_request(status)

  send_request: (status) ->
    self = @
    console.log "send request"
    if window.image_id
      likable_id = window.image_id
      likable_type = "Image"
    else if window.video_id
      likable_id = window.video_id
      likable_type = "Video"
    else if window.movie_id
      likable_id = window.movie_id
      likable_type = "Movie"
    else if window.person_id
      likable_id = window.person_id
      likable_type = "Person"

    like = new MoviesApp.Like()
    like.save ({ like: { likable_type: likable_type, likable_id: likable_id, status: status } }),
      success: (data) ->
        self.container.html self.template(likes: data.get("likes"), dislikes: data.get("dislikes"))
        if status == 1
          self.container.find(".js-like").hide()
          self.container.find(".js-dislike").show()
        else
          self.container.find(".js-dislike").hide()
          self.container.find(".js-like").show()

  hide_like: (likes) ->
    liked = ""
    $.each likes, (i, like) ->
      if like.user_id == current_user.id
        liked = "hide"
    liked

