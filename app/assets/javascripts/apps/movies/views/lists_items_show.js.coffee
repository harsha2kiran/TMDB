class MoviesApp.ListItemsShow extends Backbone.View
  template: JST['templates/list_items/show']
  className: "row list_items_show"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"
    "click .js-approve" : "approve"

  render: ->
    show = $(@el)
    list = @options.list
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
        "temp_user_id" : localStorage.temp_user_id
      success: =>
        container.remove()
        $(".notifications").html("Removed from list.").show().fadeOut(window.hide_delay)

  approve: (e) ->
    if $(e.target).hasClass("js-approve")
      id = $(e.target).find("input").val()
    else
      id = $(e.target).parents(".js-approve").find("input").val()
    container = $(e.target).parents(".item").first()
    $.ajax api_version + "list_items/" + id,
      method: "PUT"
      data:
        "list_item[id]" : id
        "list_item[list_id]" : window.list_id
        "list_item[approved]" : true
      success: =>
        $(".notifications").html("Successfully approved list item.").show().fadeOut(window.hide_delay)
        $(e.target).remove()
