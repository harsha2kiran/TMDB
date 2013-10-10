class MoviesApp.EditReleases extends Backbone.View
  template: JST['templates/releases/edit']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-release-save" : "create"
    "click .js-release-remove" : "destroy"

  render: ->
    edit_release = $(@el)
    releases = @options.releases
    edit_release.html @template(releases: releases)

    $(@el).find(".js-new-release-release-date").datepicker(
      dateFormat: "yy-mm-dd"
    )

    self = @
    $(@el).find(".js-new-release-country").autocomplete
      source: api_version + "countries/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-release-country-id").val(ui.item.id)

    this

  create: (e) ->
    self = @
    $container = $(e.target).parents(".releases")
    release_date = $container.find(".js-new-release-release-date").val()
    country_id = $container.find(".js-new-release-country-id").val()
    confirmed = $container.find(".js-new-release-confirmed :selected").val()
    # certification = $container.find(".js-new-release-certification").val()
    # primary = $container.find(".js-new-release-primary :selected").val()
    if release_date != "" && country_id != "" && confirmed != "0" # && primary != "0"
      release = new MoviesApp.Release()
      release.save ({ release: { movie_id: movie_id, release_date: release_date, country_id: country_id, confirmed: confirmed, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Successfully added release. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
    else
      $(@el).find("input, select").each (i, input) ->
        if $(input).val() == "" || $(input).val() == "0"
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  reload_items: ->
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{window.movie_id}/my_movie"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        movie = movie.get("movie")
        $(@el).remove()
        @stopListening()
        @edit_releases_view = new MoviesApp.EditReleases(releases: movie.releases)
        $(".releases").html @edit_releases_view.render().el

  destroy: (e) ->
    container = $(e.target).parents(".release").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "releases/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Release removed.").show().fadeOut(window.hide_delay)
