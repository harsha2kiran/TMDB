class MoviesApp.EditMovieMetadatas extends Backbone.View
  template: JST['templates/movie_metadatas/edit']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-metadata-update" : "update"

  render: ->
    edit_metadata = $(@el)
    movie_metadatas = @options.movie_metadatas
    locked = window.locked
    edit_metadata.html @template(movie_metadatas: movie_metadatas, locked: locked)
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
      if homepage.match(/^(ht|f)tps?:\/\/[a-z0-9-\.]+\.[a-z]{2,4}\/?([^\s<>\#%"\,\{\}\\|\\\^\[\]`]+)?$/) || homepage == ""
        movie_metadata = new MoviesApp.MovieMetadata()
        movie_metadata.save ({ movie_metadata: { movie_id: movie_id, budget: budget, homepage: homepage, imdb_id: imdb_id, runtime: runtime, status_id: status, temp_user_id: localStorage.temp_user_id } }),
          success: ->
            $(".notifications").html("Successfully updated movie metadata. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
            $($container).find("input").each (i, input) ->
              $(input).removeClass("error")
      else
        $(@el).find("input").each (i, input) ->
          $(input).removeClass("error")
        $container.find(".js-metadata-homepage").addClass("error")
    else
      $container.find(".js-metadata-status").addClass("error")


