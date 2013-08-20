class MoviesApp.Router extends Backbone.Router

  routes:
    "lists" : "lists_index"
    "lists/:id" : "lists_show"
    "genres" : "genres_index"
    "genres/:id" : "genres_show"
    "movies" : "index"
    "movies/new" : "new"
    "movies/:id" : "show"
    "movies/:id/edit" : "edit"

  initialize: ->
    console.log "MoviesApp router initialized"

  show: (id) ->
    console.log "movies router show #{id}"
    window.movie_id = id
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @show_view = new MoviesApp.Show(movie: movie)
        $(".js-content").html @show_view.render().el

  edit: (id) ->
    console.log "movies router edit #{id}"
    window.movie_id = id
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        movie = movie.get("movie")

        @edit_view = new MoviesApp.Edit(movie: movie)
        $(".js-content").html @edit_view.render().el

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

  new: ->
    console.log "add new movie"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    @new_view = new MoviesApp.New()
    $(".js-content").html @new_view.render().el

  index: ->
    console.log "movies index"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    movies = new MoviesApp.Movies()
    movies.fetch
      success: ->
        @index_view = new MoviesApp.Index(movies: movies)
        $(".js-content").html @index_view.render().el

  genres_index: ->
    console.log "genres index"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    genres = new MoviesApp.Genres()
    genres.fetch
      success: ->
        @index_view = new MoviesApp.GenresIndex(genres: genres)
        $(".js-content").html @index_view.render().el

  genres_show: (id) ->
    console.log "genres show #{id}"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    genre = new MoviesApp.Genre()
    genre.url = "/api/v1/genres/#{id}"
    genre.fetch
      success: ->
        @show_view = new MoviesApp.GenresShow(genre: genre)
        $(".js-content").html @show_view.render().el

  lists_index: ->
    console.log "lists index"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    lists = new MoviesApp.Lists()
    lists.fetch
      success: ->
        @index_view = new MoviesApp.ListsIndex(lists: lists)
        $(".js-content").html @index_view.render().el

  lists_show: (id) ->
    console.log "list show #{id}"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{id}"
    list.fetch
      success: ->
        @show_view = new MoviesApp.ListsShow(list: list)
        $(".js-content").html @show_view.render().el













