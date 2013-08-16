class MoviesApp.EditMovieKeywords extends Backbone.View
  template: JST['templates/movie_keywords/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-keyword-save" : "create"
    "click .js-keyword-remove" : "destroy"

  render: ->
    edit = $(@el)
    movie_keywords = @options.movie_keywords
    edit.html @template(movie_keywords: movie_keywords)
    this

  create: (e) ->
    self = @
    keyword_id = $(@el).find(".js-new-keyword").val()
    movie_keyword = new MoviesApp.MovieKeyword()
    movie_keyword.save ({ movie_keyword: { keyword_id: keyword_id, movie_id: movie_id } }),
      success: ->
        $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-keyword").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_keywords/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Keyword removed.").show().fadeOut(10000)
