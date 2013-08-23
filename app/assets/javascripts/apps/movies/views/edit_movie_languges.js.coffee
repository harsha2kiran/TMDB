class MoviesApp.EditMovieLanguages extends Backbone.View
  template: JST['templates/movie_languages/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-language-save" : "create"
    "click .js-language-remove" : "destroy"

  render: ->
    edit = $(@el)
    movie_languages = @options.movie_languages
    edit.html @template(movie_languages: movie_languages)

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

    this

  create: (e) ->
    self = @
    language_id = $(@el).find(".js-new-language-id").val()
    if language_id != ""
      movie_language = new MoviesApp.MovieLanguage()
      movie_language.save ({ movie_language: { language_id: language_id, movie_id: movie_id } }),
        success: ->
          $(".notifications").html("Language added. It will be active after moderation.").show().fadeOut(10000)
          $(self.el).find(".js-new-language").val("").removeClass("error")
          $(self.el).find(".js-new-language-id").val("")
    else
      $(@el).find(".js-new-language").addClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_languages/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Language removed.").show().fadeOut(10000)