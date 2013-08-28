class MoviesApp.Router extends Backbone.Router

  routes:
    "galleries" : "galleries_index"
    "galleries/new" : "galleries_new"
    "channels" : "channels_index"
    "channels/new" : "channels_new"
    "lists" : "lists_index"
    "lists/new" : "list_new"
    "lists/:id" : "lists_show"
    "genres" : "genres_index"
    "genres/:id" : "genres_show"
    "images/:id" : "images_show"
    "movies" : "index"
    "movies/new" : "new"
    "movies/:id" : "show"
    "movies/:id/edit" : "edit"
    "following" : "following"

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
        @show_view = new MoviesApp.ImagesShow(image: image)
        $(".js-content").html @show_view.render().el

        @edit_tags_view = new MoviesApp.EditTags(tags: image.get("image").tags)
        $(".tags").append @edit_tags_view.render().el
        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

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
    console.log "movies router show #{id}"
    @clear_values()
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @show_view = new MoviesApp.Show(movie: movie)
        $(".js-content").html @show_view.render().el

        type = "Movie"
        id = window.movie_id
        view = new MoviesApp.View()
        view.save ({ view: { viewable_id: id, viewable_type: type } }),
          success: ->
            console.log view

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })


  edit: (id) ->
    console.log "movies router edit #{id}"
    @clear_values()
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        movie = movie.get("movie")

        @edit_view = new MoviesApp.Edit(movie: movie)
        $(".js-content").html @edit_view.render().el

        @add_to_list_view = new MoviesApp.AddToList()
        $(".js-content").append @add_to_list_view.render().el

        @edit_movie_metadata_view = new MoviesApp.EditMovieMetadatas(movie_metadatas: movie.movie_metadatas)
        $(".js-content").append @edit_movie_metadata_view.render().el

        @edit_videos_view = new MoviesApp.EditVideos(videos: movie.videos)
        $(".js-content").append @edit_videos_view.render().el

        @edit_images_view = new MoviesApp.EditImages(images: movie.images)
        $(".js-content").append @edit_images_view.render().el

        @edit_movie_genres_view = new MoviesApp.EditMovieGenres(movie_genres: movie.movie_genres)
        $(".js-content").append @edit_movie_genres_view.render().el

        @edit_casts_view = new MoviesApp.EditCasts(casts: movie.casts)
        $(".js-content").append @edit_casts_view.render().el

        @edit_crews_view = new MoviesApp.EditCrews(crews: movie.crews)
        $(".js-content").append @edit_crews_view.render().el

        @edit_movie_keywords_view = new MoviesApp.EditMovieKeywords(movie_keywords: movie.movie_keywords)
        $(".js-content").append @edit_movie_keywords_view.render().el

        @edit_alternative_titles_view = new MoviesApp.EditAlternativeTitles(alternative_titles: movie.alternative_titles)
        $(".js-content").append @edit_alternative_titles_view.render().el

        @edit_movie_languages_view = new MoviesApp.EditMovieLanguages(movie_languages: movie.movie_languages)
        $(".js-content").append @edit_movie_languages_view.render().el

        @edit_tags_view = new MoviesApp.EditTags(tags: movie.tags)
        $(".js-content").append @edit_tags_view.render().el

        @edit_releases_view = new MoviesApp.EditReleases(releases: movie.releases)
        $(".js-content").append @edit_releases_view.render().el

        @edit_production_companies_view = new MoviesApp.EditProductionCompanies(production_companies: movie.production_companies)
        $(".js-content").append @edit_production_companies_view.render().el

        @edit_revenue_countries_view = new MoviesApp.EditRevenueCountries(revenue_countries: movie.revenue_countries)
        $(".js-content").append @edit_revenue_countries_view.render().el

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
    genre = new MoviesApp.Genre()
    genre.url = "/api/v1/genres/#{id}"
    genre.fetch
      success: ->
        @show_view = new MoviesApp.GenresShow(genre: genre)
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
    list.url = "/api/v1/lists/#{id}"
    list.fetch
      success: ->
        @show_view = new MoviesApp.ListsShow(list: list)
        $(".js-content").html @show_view.render().el

        if list.get("list").list_type == "gallery"
          @edit_images_view = new MoviesApp.EditImages(images: [], gallery: true)
          $(".add-images-form").append @edit_images_view.render().el

        $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  list_new: ->
    @clear_values()
    console.log "add new movie"
    @new_list_view = new MoviesApp.ListsNew()
    $(".js-content").html @new_list_view.render().el

  clear_values: ->
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

  following: ->
    follows = new MoviesApp.Follows()
    follows.fetch
      success: ->
        @index_view = new MoviesApp.FollowsIndex(follows: follows)
        $(".js-content").html @index_view.render().el









