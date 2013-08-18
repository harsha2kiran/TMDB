class MoviesApp.New extends Backbone.View
  template: JST['templates/movies/new']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"

  render: ->
    edit = $(@el)
    edit.html @template
    this

  create: (e) ->
    $container = $(e.target).parents(".movie")
    title = $container.find(".js-title").val()
    tagline = $container.find(".js-tagline").val()
    overview = $container.find(".js-overview").val()
    content_score = $container.find(".js-content-score").val()
    if title != ""
      movie = new MoviesApp.Movie()
      movie.save ({ movie: { title: title, tagline: tagline, overview: overview, content_score: content_score } }),
        success: ->
          $(".notifications").html("Successfully added new movie. It will be active after moderation.").show().fadeOut(10000)
          $container.find(".js-title").removeClass("error")
    else
      $container.find(".js-title").addClass("error")


