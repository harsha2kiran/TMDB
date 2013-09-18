class MoviesApp.Edit extends Backbone.View
  template: JST['templates/movies/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-update" : "update"
    "click .edit-menu-item" : "goto"

  render: ->
    edit = $(@el)
    movie = @options.movie
    locked = movie.locked
    if locked.locked
      window.locked = eval(locked.locked)
    else
      window.locked = []
    my_movie = @options.my_movie
    edit.html @template(movie: movie, locked: window.locked, my_movie: my_movie)

    @edit_movie_metadata_view = new MoviesApp.EditMovieMetadatas(movie_metadatas: movie.movie_metadatas)
    $(@el).find(".movie-metadata").html @edit_movie_metadata_view.render().el

    @edit_videos_view = new MoviesApp.EditVideos(videos: movie.videos)
    $(@el).find(".videos").html @edit_videos_view.render().el

    @edit_images_view = new MoviesApp.EditImages(images: movie.images)
    $(@el).find(".images").html @edit_images_view.render().el

    @edit_movie_genres_view = new MoviesApp.EditMovieGenres(movie_genres: movie.movie_genres)
    $(@el).find(".genres").html @edit_movie_genres_view.render().el

    @edit_casts_view = new MoviesApp.EditCasts(casts: movie.casts)
    $(@el).find(".cast").html @edit_casts_view.render().el

    @edit_crews_view = new MoviesApp.EditCrews(crews: movie.crews)
    $(@el).find(".crew").html @edit_crews_view.render().el

    @edit_movie_keywords_view = new MoviesApp.EditMovieKeywords(movie_keywords: movie.movie_keywords)
    $(@el).find(".keywords").html @edit_movie_keywords_view.render().el

    @edit_alternative_titles_view = new MoviesApp.EditAlternativeTitles(alternative_titles: movie.alternative_titles)
    $(@el).find(".alternative-titles").html @edit_alternative_titles_view.render().el

    @edit_movie_languages_view = new MoviesApp.EditMovieLanguages(movie_languages: movie.movie_languages)
    $(@el).find(".languages").html @edit_movie_languages_view.render().el

    @edit_tags_view = new MoviesApp.EditTags(tags: movie.tags)
    $(@el).find(".tags").html @edit_tags_view.render().el

    @edit_releases_view = new MoviesApp.EditReleases(releases: movie.releases)
    $(@el).find(".releases").html @edit_releases_view.render().el

    @edit_production_companies_view = new MoviesApp.EditProductionCompanies(production_companies: movie.production_companies)
    $(@el).find(".production-companies").html @edit_production_companies_view.render().el

    @edit_revenue_countries_view = new MoviesApp.EditRevenueCountries(revenue_countries: movie.revenue_countries)
    $(@el).find(".revenue-countries").html @edit_revenue_countries_view.render().el

    if localStorage && localStorage.tab != ""
    else
      localStorage.tab = "movie"
    @goto_tab_from_show()

    this

  update: (e) ->
    self = @
    $container = $(e.target).parents(".movie")
    title = $container.find(".js-title").val()
    tagline = $container.find(".js-tagline").val()
    overview = $container.find(".js-overview").val()
    content_score = $container.find(".js-content-score").val()
    original_id = $container.find(".js-original-id").val()
    approved = $container.find(".js-approved").val()
    if title != ""
      movie = new MoviesApp.Movie()
      if approved == "true"
        movie.save ({ edit_page: true, movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, original_id: original_id, temp_user_id: localStorage.temp_user_id } }),
          success: ->
            $(".notifications").html("Successfully updated movie. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
            $container.find(".js-title").removeClass("error")
            $(".show-movie").attr("href", "#/movies/#{movie.id}")
      else
        movie.url = api_version + "movies/" + movie_id
        movie.save ({ id: movie_id, movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, original_id: original_id, temp_user_id: localStorage.temp_user_id } }),
          success: ->
            $(".notifications").html("Successfully updated movie. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
            $container.find(".js-title").removeClass("error")
            $(".show-movie").attr("href", "#/movies/#{movie.id}")

    else
      $container.find(".js-title").addClass("error")

  goto_tab_from_show: ->
    $(".tab").hide()
    $(@el).find("." + localStorage.tab).show()
    localStorage.tab = ""

  goto: (e) ->
    id = $(e.target).attr("id")
    tab = id.replace("goto-", "")
    $(".tab").hide()
    $("." + tab).show()
