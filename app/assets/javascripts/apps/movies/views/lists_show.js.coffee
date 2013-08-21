class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"

  render: ->
    show = $(@el)
    list = @options.list.get("list")
    show.html @template(list: list)
    this

  destroy: (e) ->
    if $(e.target).hasClass("js-remove")
      id = $(e.target).find("input").val()
    else
      id = $(e.target).parents(".js-remove").find("input").val()
    container = $(e.target).parents(".item").first()
    $.ajax api_version + "list_items/" + id,
      method: "DELETE"
      data:
        "list_item[list_id]" : window.list_id
      success: =>
        container.remove()
        $(".notifications").html("Removed from list.").show().fadeOut(10000)
