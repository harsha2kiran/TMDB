class MoviesApp.EditMovieLanguages extends Backbone.View
  template: JST['templates/movie_languages/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-language-save" : "create"
    "click .js-language-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    movie_languages = @options.movie_languages
    @edit.html @template(movie_languages: movie_languages)

    self = @
    $(@el).find(".js-new-language").autocomplete
      source: api_version + "languages/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-language-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-language-id").val("")
        else
          self.edit.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: (e) ->
    self = @
    language_id = $(@el).find(".js-new-language-id").val()
    if language_id != ""
      movie_language = new MoviesApp.MovieLanguage()
      movie_language.save ({ movie_language: { language_id: language_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Language added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Language already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-language").val("").removeClass "error"
          $(self.el).find(".js-new-language-id").val("")
    else
      $(@el).find(".js-new-language").addClass("error")

  reload_items: ->
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{window.movie_id}/my_movie"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        movie = movie.get("movie")
        $(@el).remove()
        @stopListening()
        @edit_movie_languages_view = new MoviesApp.EditMovieLanguages(movie_languages: movie.movie_languages)
        $(".languages").html @edit_movie_languages_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_languages/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Language removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-language").val()
    if value != ""
      model = new MoviesApp.Language()
      model.save ({ language: { language: value } }),
        success: ->
          $(".notifications").html("Language added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-language").val(value).removeClass "error"
          $(self.el).find(".js-new-language-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Language is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-language").val("").removeClass "error"
          $(self.el).find(".js-new-language-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-language").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


