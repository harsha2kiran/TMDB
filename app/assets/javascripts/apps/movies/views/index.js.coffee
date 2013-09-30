class MoviesApp.Index extends Backbone.View
  template: JST['templates/movies/index']
  className: "row-fluid movies-index"

  events:
    "click .js-load-more" : "load_more"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    index = $(@el)
    movies = @options.movies
    admin = false
    if @options.admin
      admin = true
    my_movie = false
    if @options.my_movie
      my_movie = true
    index.html @template(movies: movies, admin: admin, my_movie: my_movie)
    this

  load_more: ->
    window.current_page = window.current_page + 1
    movies = new MoviesApp.Movies()
    movies.fetch
      data:
        page: window.current_page
      success: ->
        $(".js-load-more").remove()
        @index_view = new MoviesApp.Index(movies: movies)
        $(".js-content").append @index_view.render().el
        if movies.models.length < 40
          $(".js-load-more").remove()

