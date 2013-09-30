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
    self = @
    $(@el).find(".js-title").autocomplete
      source: api_version + "movies/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(".notifications").html("Movie already exist.").show().fadeOut(window.hide_delay)
        @new_view = new MoviesApp.New()
        $(".js-content").html @new_view.render().el
    this

  create: (e) ->
    $container = $(e.target).parents(".movie")
    title = $container.find(".js-title").val()
    tagline = $container.find(".js-tagline").val()
    overview = $container.find(".js-overview").val()
    content_score = $container.find(".js-content-score").val()
    if title != ""
      movie = new MoviesApp.Movie()
      movie.save ({ movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, temp_user_id: localStorage.temp_user_id } }),
        error: ->
          $(".notifications").html("Movie already exist.").show().fadeOut(window.hide_delay)
          $container.find(".js-title").addClass("error")
        success: ->
          $(".notifications").html("Successfully added new movie. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $container.find(".js-title").removeClass("error")
          window.MoviesApp.router.navigate("/#!/movies/#{movie.id}/my_movie", true)
    else
      $container.find(".js-title").addClass("error")


