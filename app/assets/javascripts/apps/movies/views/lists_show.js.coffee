class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row-fluid show-lists"

  initialize: ->
    _.bindAll this, "render"

  events:
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
    this

  create: ->
    self = @
    item_id = $(@el).find(".js-item-id").val()
    item_type = $(@el).find(".js-item-type").val()
    if item_id != "" && item_type != ""
      listable_id = item_id
      listable_type = item_type
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: localStorage.temp_user_id } }),
        error: ->
          $(".notifications").html("Cannot add this item to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-item").val("").removeClass "error"
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-item").val("").removeClass "error"
          $(self.el).find(".js-item-id").val("")
          self.reload_list_items()
    else
      $(@el).find(".js-item").addClass("error")

  reload_list_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el

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
