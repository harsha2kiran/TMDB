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
    if window.movie_id
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
      movie_id = window.movie_id
    else if window.person_id
      movie_id = $(@el).find(".js-new-tag-movie-id").val()
      person_id = window.person_id
    if person_id != "" && movie_id
      tag = new MoviesApp.Tag()
      tag.save ({ tag: { person_id: person_id, taggable_id: movie_id, taggable_type: "Movie" } }),
        success: ->
          $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(10000)
          $(self.el).find(".js-new-tag-person").val("").removeClass("error")
          $(self.el).find(".js-new-tag-person-id").val("")
          $(self.el).find(".js-new-tag-movie").val("").removeClass("error")
          $(self.el).find(".js-new-tag-movie-id").val("")
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
        $(".notifications").html("Tag removed.").show().fadeOut(10000)