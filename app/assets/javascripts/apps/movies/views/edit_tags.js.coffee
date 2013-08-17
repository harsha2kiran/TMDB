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
    $(@el).find(".js-new-tag-person").autocomplete
      source: api_version + "people/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-tag-person-id").val(ui.item.id)

    this

  create: (e) ->
    console.log "create"
    self = @
    person_id = $(@el).find(".js-new-tag-person-id").val()
    tag = new MoviesApp.Tag()
    tag.save ({ tag: { person_id: person_id, taggable_id: movie_id, taggable_type: "Movie" } }),
      success: ->
        $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-tag-person").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "tags/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Tag removed.").show().fadeOut(10000)
