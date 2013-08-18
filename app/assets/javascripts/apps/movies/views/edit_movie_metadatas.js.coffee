class MoviesApp.EditMovieMetadatas extends Backbone.View
  template: JST['templates/movie_metadatas/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-metadata-update" : "update"

  render: ->
    edit_metadata = $(@el)
    movie_metadatas = @options.movie_metadatas
    edit_metadata.html @template(movie_metadatas: movie_metadatas)

    self = @
    $(@el).find(".js-metadata-status").autocomplete
      source: api_version + "statuses/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-metadata-status-id").val(ui.item.id)

    this

  update: (e) ->
    $container = $(e.target).parents(".movie-metadatas")
    budget = $container.find(".js-metadata-budget").val()
    homepage = $container.find(".js-metadata-homepage").val()
    imdb_id = $container.find(".js-metadata-imdb-id").val()
    runtime = $container.find(".js-metadata-runtime").val()
    status = $container.find(".js-metadata-status-id").val()
    if status != ""
      movie_metadata = new MoviesApp.MovieMetadata()
      movie_metadata.save ({ movie_metadata: { movie_id: movie_id, budget: budget, homepage: homepage, imdb_id: imdb_id, runtime: runtime, status_id: status } }),
        success: ->
          $(".notifications").html("Successfully updated movie metadata. Changes will be active after moderation.").show().fadeOut(10000)
          $container.find(".js-metadata-status").removeClass("error")
    else
      $container.find(".js-metadata-status").addClass("error")


