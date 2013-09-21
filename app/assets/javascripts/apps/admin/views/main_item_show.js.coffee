class AdminApp.MainItemShow extends Backbone.View
  template: JST['templates/admin/main_item_show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-approve" : "approve"

  render: ->
    show = $(@el)
    type = @options.type
    @id = @options.id
    @type = type
    items = @options.items
    show.html @template(items: items, type: type)
    this

  approve: (e) ->
    type = @type
    id = @id
    approved_id = $(e.target).parents(".box").find(".item-id").val()
    original_id = $(".approved[value='true']").prev().val()
    if !original_id
      original_id = approved_id
    if approved_id && original_id
      $.ajax api_version + "approvals/mark",
        method: "post"
        data:
          approved_id: approved_id
          original_id: original_id
          type: type
          mark: true
        success: ->
          items = new AdminApp.MainItems()
          items.url = api_version + "approvals/main_item"
          items.fetch
            data:
              id: id
              type: type
            success: ->
              @show_view = new AdminApp.MainItemShow(id: id, items: items, type: type)
              $(".js-content").html @show_view.render().el
