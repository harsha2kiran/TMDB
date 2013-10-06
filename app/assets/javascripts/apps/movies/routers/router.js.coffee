class MoviesApp.Router extends Backbone.Router

  routes:
    "!/galleries" : "galleries_index"
    "!/galleries/new" : "galleries_new"
    "!/galleries/:id" : "galleries_show"
    "!/channels" : "channels_index"
    "!/channels/new" : "channels_new"
    "!/channels/:id" : "channels_show"
    "!/lists" : "lists_index"
    "!/lists/new" : "list_new"
    "!/lists/:id" : "lists_show"
    "!/genres" : "genres_index"
    "!/genres/:id" : "genres_show"
    "!/images/:id" : "images_show"
    "!/videos/:id" : "videos_show"
    "!/movies" : "index"
    "!/my_movies" : "my_movies"
    "!/movies/new" : "new"
    "!/movies/:id/my_movie" : "my_movie"
    "!/movies/:id" : "show"
    "!/movies/:id/edit/my_movie" : "edit_my_movie"
    "!/movies/:id/edit" : "edit"
    "!/following" : "following"

  initialize: ->
    @clear_values()
    console.log "MoviesApp router initialized"

  images_show: (id) ->
    console.log "images show #{id}"
    @clear_values()
    window.image_id = id
    image = new MoviesApp.Image()
    image.url = "/api/v1/images/#{id}"
    image.fetch
      success: ->
        if image.get("image")
          @show_view = new MoviesApp.ImagesShow(image: image)
          $(".js-content").html @show_view.render().el

          @edit_tags_view = new MoviesApp.EditTags(tags: image.get("image").tags)
          $(".tags").append @edit_tags_view.render().el
          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

          type = "Image"
          id = window.image_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type, temp_user_id: localStorage.temp_user_id } }),
            success: ->
              console.log view
        else
          @show_view = new MoviesApp.NotFound(type: "image")
          $(".js-content").html @show_view.render().el

  videos_show: (id) ->
    console.log "videos show #{id}"
    @clear_values()
    window.video_id = id
    video = new MoviesApp.Video()
    video.url = api_version + "videos/#{id}"
    video.fetch
      success: ->
        if video.get("video")
          @show_view = new MoviesApp.VideosShow(video: video)
          $(".js-content").html @show_view.render().el

          @edit_tags_view = new MoviesApp.EditTags(tags: video.get("video").tags)
          $(".tags").append @edit_tags_view.render().el

          type = "Video"
          id = window.video_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type, temp_user_id: localStorage.temp_user_id } }),
            success: ->
              console.log view
        else
          @show_view = new MoviesApp.NotFound(type: "video")
          $(".js-content").html @show_view.render().el

  galleries_index: ->
    console.log "galleries index"
    @clear_values()
    lists = new MoviesApp.Lists()
    lists.url = api_version + "lists/galleries"
    lists.fetch
      success: ->
        @index_view = new MoviesApp.ListsIndex(lists: lists)
        $(".js-content").html @index_view.render().el

  galleries_new: ->
    @clear_values()
    console.log "add new gallery"
    @new_list_view = new MoviesApp.ListsNew(list_type: "gallery")
    $(".js-content").html @new_list_view.render().el

  channels_index: ->
    console.log "channels index"
    @clear_values()
    lists = new MoviesApp.Lists()
    lists.url = api_version + "lists/channels"
    lists.fetch
      success: ->
        @index_view = new MoviesApp.ListsIndex(lists: lists)
        $(".js-content").html @index_view.render().el

  channels_new: ->
    @clear_values()
    console.log "add new channel"
    @new_list_view = new MoviesApp.ListsNew(list_type: "channel")
    $(".js-content").html @new_list_view.render().el

  show: (id) ->
    @show_movie_action(id, "show")

  my_movie: (id) ->
    @show_movie_action(id, "my_movie")

  show_movie_action: (id, my_movie) ->
    console.log "movies router my movie #{id}"
    @clear_values()
    window.movie_id = id
    movie = new MoviesApp.Movie()
    if my_movie == "my_movie"
      movie.url = api_version + "movies/#{id}/my_movie"
    else
      movie.url = api_version + "movies/#{id}"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        if movie.get("movie")
          @show_view = new MoviesApp.Show(movie: movie, my_movie: my_movie)
          $(".js-content").html @show_view.render().el

          if current_user
            @add_to_list_view = new MoviesApp.AddToList()
            $(".add-to-list").html @add_to_list_view.render().el

          type = "Movie"
          id = window.movie_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type, temp_user_id: localStorage.temp_user_id } }),
            success: ->
              console.log view

          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })
        else
          @show_view = new MoviesApp.NotFound(type: "movie")
          $(".js-content").html @show_view.render().el

  edit: (id) ->
    @edit_movie_action(id, "edit")

  edit_my_movie: (id) ->
    @edit_movie_action(id, "my_movie")

  edit_movie_action: (id, my_movie) ->
    console.log "movies router edit #{id}"
    @clear_values()
    window.movie_id = id
    movie = new MoviesApp.Movie()
    if my_movie == "my_movie"
      movie.url = "/api/v1/movies/#{id}/my_movie"
    else
      movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        movie = movie.get("movie")

        @edit_view = new MoviesApp.Edit(movie: movie, my_movie: my_movie)
        $(".js-content").html @edit_view.render().el

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  new: ->
    console.log "add new movie"
    @clear_values()
    @new_view = new MoviesApp.New()
    $(".js-content").html @new_view.render().el

  index: ->
    console.log "movies index"
    @clear_values()
    movies = new MoviesApp.Movies()
    movies.fetch
      success: ->
        @index_view = new MoviesApp.Index(movies: movies)
        $(".js-content").html @index_view.render().el
        if movies.models.length < 40
          $(".js-load-more").remove()

  my_movies: ->
    console.log "my movies"
    @clear_values()
    movies = new MoviesApp.Movies()
    movies.url = api_version + "movies/my_movies"
    movies.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: ->
        @index_view = new MoviesApp.Index(movies: movies, my_movie: true)
        $(".js-content").html @index_view.render().el
        if movies.models.length < 40
          $(".js-load-more").remove()

  genres_index: ->
    console.log "genres index"
    @clear_values()
    genres = new MoviesApp.Genres()
    genres.fetch
      success: ->
        @index_view = new MoviesApp.GenresIndex(genres: genres)
        $(".js-content").html @index_view.render().el

  genres_show: (id) ->
    console.log "genres show #{id}"
    @clear_values()
    window.genre_id = id
    genre = new MoviesApp.Genre()
    genre.url = "/api/v1/genres/#{id}"
    genre.fetch
      success: ->
        if genre.get("genre")
          @show_view = new MoviesApp.GenresShow(genre: genre)
          $(".js-content").html @show_view.render().el
        else
          @show_view = new MoviesApp.NotFound(type: "genre")
          $(".js-content").html @show_view.render().el

  lists_index: ->
    console.log "lists index"
    @clear_values()
    lists = new MoviesApp.Lists()
    lists.fetch
      success: ->
        @index_view = new MoviesApp.ListsIndex(lists: lists)
        $(".js-content").html @index_view.render().el

  lists_show: (id) ->
    console.log "list show #{id}"
    @clear_values()
    window.list_id = id
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          window.list_type = "List"
          @show_view = new MoviesApp.ListsShow(list: list)
          $(".js-content").html @show_view.render().el

          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el

          if list.get("list").list_type == "gallery"
            window.list_type = "gallery"
            @edit_images_view = new MoviesApp.EditImagesGallery(images: [])
            $(".add-images-form").append @edit_images_view.render().el
            $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

          if list.get("list").list_type == "channel"
            window.list_type = "channel"
            @edit_videos_view = new MoviesApp.EditVideos(videos: [], channel: true)
            $(".add-videos-form").append @edit_videos_view.render().el
        else
          @show_view = new MoviesApp.NotFound(type: "list")
          $(".js-content").html @show_view.render().el

  list_new: ->
    @clear_values()
    console.log "add new movie"
    @new_list_view = new MoviesApp.ListsNew()
    $(".js-content").html @new_list_view.render().el

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
    try
      delete window.image_id
    catch e
      window.image_id = undefined
    try
      delete window.video_id
    catch e
      window.video_id = undefined
    try
      delete window.genre_id
    catch e
      window.genre_id = undefined

  following: ->
    follows = new MoviesApp.Follows()
    follows.fetch
      success: ->
        @index_view = new MoviesApp.FollowsIndex(follows: follows)
        $(".js-content").html @index_view.render().el









