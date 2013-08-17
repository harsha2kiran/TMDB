class MoviesApp.EditAlternativeTitles extends Backbone.View
  template: JST['templates/alternative_titles/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-alternative-title-save" : "create"
    "click .js-alternative-title-remove" : "destroy"

  render: ->
    edit = $(@el)
    alternative_titles = @options.alternative_titles
    edit.html @template(alternative_titles: alternative_titles)

    self = @
    $(@el).find(".js-new-alternative-title-language").autocomplete
      source: api_version + "languages/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-alternative-title-language-id").val(ui.item.id)

    this

  create: (e) ->
    console.log "create"
    self = @
    title = $(@el).find(".js-new-alternative-title").val()
    language_id = $(@el).find(".js-new-alternative-title-language-id").val()
    alternative_title = new MoviesApp.AlternativeTitle()
    alternative_title.save ({ alternative_title: { alternative_title: title, language_id: language_id, movie_id: movie_id } }),
      success: ->
        $(".notifications").html("Alternative title added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-alternative-title").val("")
        $(self.el).find(".js-new-alternative-title-language").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "alternative_titles/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Alternative title removed.").show().fadeOut(10000)
