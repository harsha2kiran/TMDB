class MoviesApp.Keywords extends Backbone.View
  template: JST['templates/keywords/index']
  className: "row-fluid keywords-index"

  events:
    "click .js-remove" : "remove"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    keywords = @options.keywords
    index.html @template(keywords: keywords)
    this

  remove: (e) ->
    $(e.target).parents(".keyword").first().remove()
