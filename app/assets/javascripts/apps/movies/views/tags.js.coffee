class MoviesApp.Tags extends Backbone.View
  template: JST['templates/tags/index']
  className: "col-md-11 tags-index"

  events:
    "click .js-remove" : "remove"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    tags = @options.tags
    index.html @template(tags: tags)
    this

  remove: (e) ->
    $(e.target).parents(".tag").first().remove()
