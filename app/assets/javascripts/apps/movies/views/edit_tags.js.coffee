class MoviesApp.EditTags extends Backbone.View
  template: JST['templates/tags/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-tag-save" : "create"
    "click .js-tag-remove" : "destroy"
    "click .js-new-movie-add-yes" : "add_new_movie"
    "click .js-new-movie-add-no" : "cancel"
    "click .js-new-person-add-yes" : "add_new_person"
    "click .js-new-person-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    tags = @options.tags
    @edit.html @template(tags: tags)

    self = @
    if window.movie_id || window.image_id || window.video_id
      $(@el).find(".js-new-tag-person").autocomplete
        source: api_version + "people/search?temp_user_id=" + localStorage.temp_user_id
        minLength: 2
        messages:
          noResults: ''
          results: ->
            ''
        select: (event, ui) ->
          $(self.el).find(".js-new-tag-person-id").val(ui.item.id)
        response: (event, ui) ->
          if ui.content.length == 0
            $(self.el).find(".js-new-person-info, .js-new-person-add-form").show()
            $(self.el).find(".js-new-person-id").val("")
    else if window.person_id
      $(@el).find(".js-new-tag-movie").autocomplete
        source: api_version + "movies/search?temp_user_id=" + localStorage.temp_user_id
        minLength: 2
        messages:
          noResults: ''
          results: ->
            ''
        select: (event, ui) ->
          $(self.el).find(".js-new-tag-movie-id").val(ui.item.id)
        response: (event, ui) ->
          if ui.content.length == 0
            $(self.el).find(".js-new-movie-info, .js-new-movie-add-form").show()
            $(self.el).find(".js-new-movie-id").val("")
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
          self.reload_items()

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

  reload_items: ->
    if window.movie_id
      movie = new MoviesApp.Movie()
      movie.url = "/api/v1/movies/#{window.movie_id}"
      movie.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          movie = movie.get("movie")
          $(@el).remove()
          @stopListening()
          @edit_tags_view = new MoviesApp.EditTags(tags: movie.tags)
          $(".tags").html @edit_tags_view.render().el
    else if window.person_id
      person = new PeopleApp.Person()
      person.url = "/api/v1/people/#{window.person_id}"
      person.fetch
        data:
          temp_user_id: localStorage.temp_user_id
        success: =>
          person = person.get("person")
          $(@el).remove()
          @stopListening()
          @edit_tags_view = new MoviesApp.EditTags(tags: person.tags)
          $(".tags").html @edit_tags_view.render().el

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

  add_new_movie: (e) ->
    self = @
    value = @edit.find(".js-new-tag-movie").val()
    if value != ""
      model = new MoviesApp.Movie()
      model.save ({ movie: { title: value, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Movie added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-movie").val(value).removeClass "error"
          $(self.el).find(".js-new-tag-movie-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Movie is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-movie").val("").removeClass "error"
          $(self.el).find(".js-new-tag-movie-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-movie").addClass("error")

  add_new_person: (e) ->
    self = @
    value = @edit.find(".js-new-tag-person").val()
    if value != ""
      model = new PeopleApp.Person()
      model.save ({ person: { name: value, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Person added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-person").val(value).removeClass "error"
          $(self.el).find(".js-new-tag-person-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Person is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag-person").val("").removeClass "error"
          $(self.el).find(".js-new-tag-person-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-tag-person").addClass("error")

  cancel: ->
    @edit.find(".js-new-person-info, .js-new-person-add-form").hide()
    @edit.find(".js-new-movie-info, .js-new-movie-add-form").hide()

