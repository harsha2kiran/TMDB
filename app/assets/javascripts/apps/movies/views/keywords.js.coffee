class MoviesApp.Keywords extends Backbone.View
  template: JST['templates/keywords/index']
  className: "col-md-11 keywords-index"

  events:
    "click .js-remove" : "remove"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    keywords = @options.keywords
    index.html @template(keywords: keywords)
    $(".ui-autocomplete-input").val ""
    this

  remove: (e) ->
    $(e.target).parents(".keyword").first().remove()
