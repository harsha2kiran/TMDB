class MoviesApp.EditMovieKeywords extends Backbone.View
  template: JST['templates/movie_keywords/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-keyword-save" : "create"
    "click .js-keyword-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    movie_keywords = @options.movie_keywords
    @edit.html @template(movie_keywords: movie_keywords)

    self = @
    $(@el).find(".js-new-keyword").autocomplete
      source: api_version + "keywords/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-keyword-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-keyword-id").val("")
    this

  create: (e) ->
    self = @
    keyword_id = $(@el).find(".js-new-keyword-id").val()
    if keyword_id != ""
      movie_keyword = new MoviesApp.MovieKeyword()
      movie_keyword.save ({ movie_keyword: { keyword_id: keyword_id, movie_id: movie_id } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-keyword-id").val("")
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-keyword-id").val("")
    else
      $(@el).find(".js-new-keyword").addClass("error").focus()

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "movie_keywords/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Keyword removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-keyword").val()
    if value != ""
      model = new MoviesApp.Keyword()
      model.save ({ keyword: { keyword: value } }),
        success: ->
          $(self.el).find(".js-new-keyword").val(value).removeClass "error"
          $(self.el).find(".js-new-keyword-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-keyword-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-keyword").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()

