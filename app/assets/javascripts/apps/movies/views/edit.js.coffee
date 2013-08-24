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
        movie.save ({ movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, original_id: original_id } }),
          success: ->
            $(".notifications").html("Successfully updated movie. Changes will be active after moderation.").show().fadeOut(10000)
            $container.find(".js-title").removeClass("error")
            $(".show-movie").attr("href", "#/movies/#{movie.id}")
      else
        movie.url = api_version + "movies/" + movie_id
        movie.save ({ id: movie_id, movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, original_id: original_id } }),
          success: ->
            $(".notifications").html("Successfully updated movie. Changes will be active after moderation.").show().fadeOut(10000)
            $container.find(".js-title").removeClass("error")
            $(".show-movie").attr("href", "#/movies/#{movie.id}")

    else
      $container.find(".js-title").addClass("error")
