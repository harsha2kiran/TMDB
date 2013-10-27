class AdminApp.MetaTags extends Backbone.View
  template: JST['templates/admin/meta_tags']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-meta-update" : "update"

  render: ->
    show = $(@el)
    type = @options.type
    @id = @options.id
    @type = type
    items = @options.items
    show.html @template(items: items, type: type)
    this

  update: (e) ->
    console.log "update"
    meta_title = $(@el).find(".js-meta-title").val()
    meta_keywords = $(@el).find(".js-meta-keywords").val()
    meta_description = $(@el).find(".js-meta-description").val()
    if @type == "Movie"
      model = new MoviesApp.Movie()
      model.url = api_version + "movies/" + @id
      model.set({ id: @id, movie: { meta_title: meta_title, meta_description: meta_description, meta_keywords: meta_keywords  } })
    else
      model = new PeopleApp.Person()
      model.url = api_version + "people/" + @id
      model.set({ id: @id, person: { meta_title: meta_title, meta_description: meta_description, meta_keywords: meta_keywords  } })
    model.save null,
      success: ->
        $(".notifications").html("Successfully updated meta tags.").show().fadeOut(window.hide_delay)


