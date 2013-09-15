class MoviesApp.ListsIndex extends Backbone.View
  template: JST['templates/lists/index']
  className: "row-fluid lists-index"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"

  render: ->
    index = $(@el)
    lists = @options.lists
    index.html @template(lists: lists)
    this

  destroy: (e) ->
    id = $(@el).find(".js-remove input").val()
    container = $(e.target).parents(".span12").first()
    if confirm("Remove list?") == true
      $.ajax api_version + "lists/" + id,
        method: "DELETE"
        success: =>
          container.remove()
          $(".notifications").html("List removed.").show().fadeOut(window.hide_delay)
