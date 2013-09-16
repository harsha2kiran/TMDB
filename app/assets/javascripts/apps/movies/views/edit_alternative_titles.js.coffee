class MoviesApp.EditAlternativeTitles extends Backbone.View
  template: JST['templates/alternative_titles/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-alternative-title-save" : "create"
    "click .js-alternative-title-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    alternative_titles = @options.alternative_titles
    @edit.html @template(alternative_titles: alternative_titles)

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
      response: (event, ui) ->
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-alternative-title-language-id").val("")
        else
          self.edit.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: (e) ->
    console.log "create"
    self = @
    title = $(@el).find(".js-new-alternative-title").val()
    language_id = $(@el).find(".js-new-alternative-title-language-id").val()
    if title != "" && language_id != ""
      alternative_title = new MoviesApp.AlternativeTitle()
      alternative_title.save ({ alternative_title: { alternative_title: title, language_id: language_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Alternative title added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: ->
          console.log "error"
          $(".notifications").html("This alternative title already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-alternative-title").val("").removeClass("error")
          $(self.el).find(".js-new-alternative-title-language").val("").removeClass("error")
          $(self.el).find(".js-new-alternative-title-language-id").val("")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  reload_items: ->
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{window.movie_id}"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        movie = movie.get("movie")
        $(@el).remove()
        @stopListening()
        @edit_alternative_titles_view = new MoviesApp.EditAlternativeTitles(alternative_titles: movie.alternative_titles)
        $(".alternative-titles").html @edit_alternative_titles_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "alternative_titles/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Alternative title removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-alternative-title-language").val()
    if value != ""
      model = new MoviesApp.Language()
      model.save ({ language: { language: value } }),
        success: ->
          $(".notifications").html("Language added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-alternative-title-language.js-new-language").val(value).removeClass "error"
          $(self.el).find(".js-new-alternative-title-language-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Language is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-alternative-title-language").val("").removeClass "error"
          $(self.el).find(".js-new-alternative-title-language-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-alternative-title-language").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()

