class AdminApp.Router extends Backbone.Router

  routes:
    "admin/items_index/:type" : "items_index"
    "admin/movies" : "movies"
    "admin/people" : "people"
    "admin/galleries" : "galleries"
    "admin/users" : "users"
    "admin/movies/:id" : "movie"
    "admin/people/:id" : "person"
    "admin/users/:id" : "user"

  initialize: ->
    @clear_values()

  movies: ->
    type = "Movie"
    @index_main_items(type)

  people: ->
    type = "Person"
    @index_main_items(type)

  users: ->
    type = "User"
    @index_main_items(type)

  galleries: ->
    window.list_type = "gallery"
    type = "Gallery"
    if current_user && current_user.user_type == "admin"
      console.log "admin galleries index"
      @clear_values()
      @index_view = new AdminApp.MainItemsIndex(items: [], type: type)
      $(".js-content").html @index_view.render().el

  index_main_items: (type) ->
    if current_user && current_user.user_type == "admin"
      console.log "admin main items index"
      @clear_values()
      @index_view = new AdminApp.MainItemsIndex(items: [], type: type)
      $(".js-content").html @index_view.render().el

  movie: (id) ->
    type = "Movie"
    @show_main_item(id, type)

  person: (id) ->
    type = "Person"
    @show_main_item(id, type)

  user: (id) ->
    if current_user && current_user.user_type == "admin"
      type = "User"
      user = new AdminApp.Item()
      user.url = api_version + "users/#{id}?moderate=true"
      user.fetch
        success: ->
          @show_view = new AdminApp.MainItemShow(id: id, items: user, type: type)
          $(".js-content").html @show_view.render().el
          @details_view = new AdminApp.ItemsIndex(items: user, type: type)
          $(".js-item-details").html @details_view.render().el

  show_main_item: (id, type) ->
    if current_user && current_user.user_type == "admin"
      console.log "admin router show main item #{id}"
      @clear_values()
      if type == "Movie"
        window.movie_id = id
      else if type == "Person"
        window.person_id = id
      items = new AdminApp.MainItems()
      items.url = api_version + "approvals/main_item"
      items.fetch
        data:
          id: id
          type: type
        success: ->
          @show_view = new AdminApp.MainItemShow(id: id, items: items, type: type)
          $(".js-content").html @show_view.render().el

          details = new AdminApp.MainItems()
          if type == "Movie"
            details.url = api_version + "movies/#{id}?moderate=true"
          else
            details.url = api_version + "people/#{id}?moderate=true"
          details.fetch
            success: ->
              @details_view = new AdminApp.ItemsIndex(items: details, type: type)
              $(".js-item-details").html @details_view.render().el
          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

          if type == "Movie" || type == "Person"
            @meta_tags_view = new AdminApp.MetaTags(id: id, items: items, type: type)
            $(".js-item-meta-tags").html @meta_tags_view.render().el

  items_index: (type) ->
    if current_user && current_user.user_type == "admin"
      console.log "admin items index"
      @clear_values()
      items = new AdminApp.Items()
      items.url = api_version + "approvals/items"
      items.fetch
        data:
          type: type
        success: ->
          @index_view = new AdminApp.ItemsIndex(items: items, type: type)
          $(".js-content").html @index_view.render().el

  clear_values: ->
    window.current_page = 1
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    try
      delete window.list_id
    catch e
      window.list_id = undefined
