class MoviesApp.Router extends Backbone.Router

  routes:
    "movies/:id" : "show"
    "movies/:id/edit" : "edit"

  initialize: ->
    console.log "MoviesApp router initialized"

  show: (id) ->
    console.log "movies router show #{id}"
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        @show_view = new MoviesApp.Show(movie: movie)
        $(".js-content").html @show_view.render().el

  edit: (id) ->
    console.log "movies router edit #{id}"
    window.movie_id = id
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{id}"
    movie.fetch
      success: ->
        movie = movie.get("movie")

        @edit_view = new MoviesApp.Edit(movie: movie)
        $(".js-content").append @edit_view.render().el

        @edit_movie_metadata_view = new MoviesApp.EditMovieMetadatas(movie_metadatas: movie.movie_metadatas)
        $(".js-content").append @edit_movie_metadata_view.render().el

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

