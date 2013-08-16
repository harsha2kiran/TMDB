class MoviesApp.Edit extends Backbone.View
  template: JST['templates/movies/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-update" : "update"

  render: ->
    edit = $(@el)
    movie = @options.movie
    edit.html @template(movie: movie)
    this

  update: (e) ->
    $container = $(e.target).parents(".movie")
    title = $container.find(".js-title").val()
    tagline = $container.find(".js-tagline").val()
    overview = $container.find(".js-overview").val()
    content_score = $container.find(".js-content-score").val()
    movie = new MoviesApp.Movie()
    movie.save ({ movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, original_id: movie_id } }),
      success: ->
        $(".notifications").html("Successfully updated movie. Changes will be active after moderation.").show().fadeOut(10000)

