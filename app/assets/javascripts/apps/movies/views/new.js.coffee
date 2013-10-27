class MoviesApp.New extends Backbone.View
  template: JST['templates/movies/new']
  className: "row"

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
    title = $.trim($container.find(".js-title").val())
    tagline = $.trim($container.find(".js-tagline").val())
    overview = $.trim($container.find(".js-overview").val())
    content_score = $container.find(".js-content-score").val()
    if title != ""
      values = [title, tagline, overview]
      meta_tags = window.generate_meta_tags("Movie", values)
      movie = new MoviesApp.Movie()
      movie.save ({ movie: { title: title, tagline: tagline, overview: overview, content_score: content_score, temp_user_id: localStorage.temp_user_id, meta_title: meta_tags.meta_title, meta_keywords: meta_tags.meta_keywords, meta_description: meta_tags.meta_description } }),
        error: ->
          $(".notifications").html("Movie already exist.").show().fadeOut(window.hide_delay)
          $container.find(".js-title").addClass("error")
        success: ->
          $(".notifications").html("Successfully added new movie. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $container.find(".js-title").removeClass("error")
          window.MoviesApp.router.navigate("/#!/movies/#{movie.id}/my_movie", true)
    else
      $container.find(".js-title").addClass("error")


