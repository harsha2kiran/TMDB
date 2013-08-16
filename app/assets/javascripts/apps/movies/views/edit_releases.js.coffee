class MoviesApp.EditReleases extends Backbone.View
  template: JST['templates/releases/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-release-save" : "create"
    "click .js-release-remove" : "destroy"

  render: ->
    edit_release = $(@el)
    releases = @options.releases
    console.log releases
    edit_release.html @template(releases: releases)
    this

  create: (e) ->
    $container = $(e.target).parents(".releases")
    release_date = $container.find(".js-new-release-release-date").val()
    country_id = $container.find(".js-new-release-country").val()
    confirmed = $container.find(".js-new-release-confirmed").val()
    certification = $container.find(".js-new-release-certification").val()
    primary = $container.find(".js-new-release-primary").val()
    release = new MoviesApp.Release()
    release.save ({ release: { movie_id: movie_id, release_date: release_date, country_id: country_id, confirmed: confirmed, certification: certification, primary: primary } }),
      success: ->
        $(".notifications").html("Successfully added release. Changes will be active after moderation.").show().fadeOut(10000)

  destroy: (e) ->
    container = $(e.target).parents(".release").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "releases/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Release removed.").show().fadeOut(10000)
