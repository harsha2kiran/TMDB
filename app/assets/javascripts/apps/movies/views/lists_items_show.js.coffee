class MoviesApp.ListItemsShow extends Backbone.View
  template: JST['templates/list_items/show']
  className: "row list-items-show"

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

#     $.ajax api_version + "list_items/" + id,
#       method: "PUT"
#       data:
#         "list_item[id]" : id
#         "list_item[list_id]" : window.list_id
#         "list_item[approved]" : true

    $.ajax api_version + "approvals/mark",
      method: "post"
      data:
        approved_id: id
        type: "ListItem"
        mark: true
      success: =>
        console.log "mark success"
        $(".notifications").html("Successfully approved list item.").show().fadeOut(window.hide_delay)
        $(e.target).remove()

#         user_id = parent.find(".js-user-temp-id").attr("data-user-id")
#         temp_user_id = parent.find(".js-user-temp-id").attr("data-temp-user-id")
#         $.ajax api_version + "approvals/add_remove_pending",
#           method: "post"
#           data:
#             pendable_id: id
#             pendable_type: "ListItem"
#             user_id: user_id
#             temp_user_id: temp_user_id
#             approvable_id: image_id
#             approvable_type: "Image"
#             approval_type: "approve"
#           success: (response) ->
#             console.log response
#             $(".notifications").html("Successfully approved list item.").show().fadeOut(window.hide_delay)
#             $(e.target).remove()

