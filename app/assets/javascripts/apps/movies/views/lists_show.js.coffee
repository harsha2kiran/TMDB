class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row-fluid show-lists"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"
    "click .js-create" : "create"
    "click .follow" : "follow"
    "click .following" : "unfollow"

  render: ->
    show = $(@el)
    list = @options.list.get("list")
    show.html @template(list: list)

    $(@el).find(".js-item").autocomplete
      source: api_version + "search?for_list=true"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(show).find(".js-item-type").val(ui.item.type)
        $(show).find(".js-item-id").val(ui.item.id)
        # window.location = root_path + "/#" + app + "/" + ui.item.id
    this

  create: ->
    self = @
    item_id = $(@el).find(".js-item-id").val()
    item_type = $(@el).find(".js-item-type").val()
    if item_id != "" && item_type != ""
      listable_id = item_id
      listable_type = item_type
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-item").val("").removeClass "error"
          $(self.el).find(".js-item-id").val("")
          list = new MoviesApp.List()
          list.url = "/api/v1/lists/#{window.list_id}"
          list.fetch
            success: ->
              @show_view = new MoviesApp.ListsShow(list: list)
              $(".js-content").html @show_view.render().el
    else
      $(@el).find(".js-item").addClass("error")

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
        $(".notifications").html("Removed from list.").show().fadeOut(window.hide_delay)

  follow: (e) ->
    $self = $(e.target)
    type = "List"
    id = window.list_id
    follow = new MoviesApp.Follow()
    follow.save ({ follow: { followable_id: id, followable_type: type } }),
      success: ->
        $self.addClass("following").removeClass("follow").html("Already following")

  unfollow: (e) ->
    $self = $(e.target)
    type = "List"
    id = window.list_id
    $.ajax api_version + "follows/test",
      method: "DELETE"
      data:
        followable_id: id
        followable_type: type
      success: =>
        $self.addClass("follow").removeClass("following").html("Follow")
