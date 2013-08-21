class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "destroy"
    "click .js-create" : "create"

  render: ->
    show = $(@el)
    list = @options.list.get("list")
    show.html @template(list: list)
    $(@el).find(".js-movie").autocomplete
      source: api_version + "movies/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(show).find(".js-movie-id").val(ui.item.id)
    this

  create: ->
    self = @
    item_id = $(@el).find(".js-movie-id").val()
    if item_id
      listable_id = item_id
      listable_type = "Movie"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(10000)
          $(self.el).find(".js-movie").val("").removeClass "error"
          $(self.el).find(".js-movie-id").val("")
          list = new MoviesApp.List()
          list.url = "/api/v1/lists/#{window.list_id}"
          list.fetch
            success: ->
              @show_view = new MoviesApp.ListsShow(list: list)
              $(".js-content").html @show_view.render().el
    else
      $(@el).find(".js-movie").addClass("error")

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
