class MoviesApp.ListsIndex extends Backbone.View
  template: JST['templates/lists/index']
  className: "row lists-index"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-load-more" : "load_more"
    "click .js-remove" : "destroy"

  render: ->
    index = $(@el)
    lists = @options.lists
    index.html @template(lists: lists)
    this

  destroy: (e) ->
    id = $(@el).find(".js-remove input").val()
    container = $(e.target).parents(".col-md-12").first()
    if confirm("Remove list?") == true
      $.ajax api_version + "lists/" + id,
        method: "DELETE"
        success: =>
          container.remove()
          $(".notifications").html("List removed.").show().fadeOut(window.hide_delay)

  load_more: ->
    console.log "load_more"
    window.current_page = window.current_page + 1
    lists = new MoviesApp.Lists()
    if window.list_type == "List"
      lists.url = api_version + "lists"
    else if window.list_type == "gallery"
      lists.url = api_version + "lists/galleries"
    else if window.list_type == "channel"
      lists.url = api_version + "lists/channels"
    lists.fetch
      data:
        page: window.current_page
      success: ->
        $(".js-load-more").remove()
        @index_view = new MoviesApp.ListsIndex(lists: lists)
        $(".js-content").append @index_view.render().el
        if lists.models.length < 20
          $(".js-load-more").remove()

