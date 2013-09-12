class MoviesApp.EditTags extends Backbone.View
  template: JST['templates/tags/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-tag-save" : "create"
    "click .js-tag-remove" : "destroy"

  render: ->
    edit = $(@el)
    tags = @options.tags
    edit.html @template(tags: tags)

    self = @
    if window.movie_id || window.image_id || window.video_id
      $(@el).find(".js-new-tag-person").autocomplete
        source: api_version + "people/search"
        minLength: 2
        messages:
          noResults: ''
          results: ->
            ''
        select: (event, ui) ->
          $(self.el).find(".js-new-tag-person-id").val(ui.item.id)
    else if window.person_id
      $(@el).find(".js-new-tag-movie").autocomplete
        source: api_version + "movies/search"
        minLength: 2
        messages:
          noResults: ''
          results: ->
            ''
        select: (event, ui) ->
          $(self.el).find(".js-new-tag-movie-id").val(ui.item.id)
    this

  create: (e) ->
    console.log "create"
    self = @
    if window.movie_id
      person_id = $(@el).find(".js-new-tag-person-id").val()
      taggable_id = window.movie_id
      taggable_type = "Movie"
    else if window.person_id
      taggable_id = $(@el).find(".js-new-tag-movie-id").val()
      person_id = window.person_id
      taggable_type = "Movie"
    else if window.image_id
      person_id = $(@el).find(".js-new-tag-person-id").val()
      taggable_id = window.image_id
      taggable_type = "Image"
    else if window.video_id
      person_id = $(@el).find(".js-new-tag-person-id").val()
      taggable_id = window.video_id
      taggable_type = "Video"

    if person_id != "" && taggable_id != ""
      tag = new MoviesApp.Tag()
      tag.save ({ tag: { person_id: person_id, taggable_id: taggable_id, taggable_type: taggable_type, temp_user_id: localStorage.temp_user_id } }),
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Tag already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-person").val("").removeClass("error")
          $(self.el).find(".js-new-tag-person-id").val("")
          $(self.el).find(".js-new-tag-movie").val("").removeClass("error")
          $(self.el).find(".js-new-tag-movie-id").val("")
        success: ->
          $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-person").val("").removeClass("error")
          $(self.el).find(".js-new-tag-person-id").val("")
          $(self.el).find(".js-new-tag-movie").val("").removeClass("error")
          $(self.el).find(".js-new-tag-movie-id").val("")

          if taggable_type == "Image" || taggable_type == "Video"
            $.ajax api_version + "approvals/mark",
              method: "post"
              data:
                approved_id: tag.id
                type: "Tag"
                mark: true
              success: ->
                self.reload(taggable_type, taggable_id)
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "tags/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Tag removed.").show().fadeOut(window.hide_delay)

  reload: (type, id) ->
    if type == "Image"
      image = new MoviesApp.Image()
      image.url = "/api/v1/images/#{id}"
      image.fetch
        success: ->
          @show_view = new MoviesApp.ImagesShow(image: image)
          $(".js-content").html @show_view.render().el
          @edit_tags_view = new MoviesApp.EditTags(tags: image.get("image").tags)
          $(".tags").append @edit_tags_view.render().el
          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })
    else if type == "Video"
      video = new MoviesApp.Video()
      video.url = api_version + "videos/#{id}"
      video.fetch
        success: ->
          @show_view = new MoviesApp.VideosShow(video: video)
          $(".js-content").html @show_view.render().el
          @edit_tags_view = new MoviesApp.EditTags(tags: video.get("video").tags)
          $(".tags").append @edit_tags_view.render().el

