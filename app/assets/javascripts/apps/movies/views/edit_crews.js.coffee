class MoviesApp.EditCrews extends Backbone.View
  template: JST['templates/crews/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-crew-save" : "create"
    "click .js-crew-remove" : "destroy"

  render: ->
    edit = $(@el)
    crews = @options.crews
    edit.html @template(crews: crews)

    self = @
    $(@el).find(".js-new-crew-person").autocomplete
      source: api_version + "people/search?temp_user_id=" + localStorage.temp_user_id
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-crew-person-id").val(ui.item.id)

    $(@el).find(".js-new-crew-movie").autocomplete
      source: api_version + "movies/search?temp_user_id=" + localStorage.temp_user_id
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-crew-movie-id").val(ui.item.id)
    this

  create: (e) ->
    console.log "create"
    self = @
    job = $(@el).find(".js-new-crew-job").val()
    if window.movie_id
      person_id = $(@el).find(".js-new-crew-person-id").val()
      movie_id = window.movie_id
    else if window.person_id
      person_id = window.person_id
      movie_id = $(@el).find(".js-new-crew-movie-id").val()
    if job != "" && person_id != "" && movie_id != ""
      crew = new MoviesApp.Crew()
      crew.save ({ crew: { job: job, person_id: person_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Crew member added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-crew-job").val("").removeClass("error")
          $(self.el).find(".js-new-crew-person").val("").removeClass("error")
          $(self.el).find(".js-new-crew-person-id").val("")
        error: ->
          console.log "error"
          $(".notifications").html("This crew member already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-crew-job").val("").removeClass("error")
          $(self.el).find(".js-new-crew-person").val("").removeClass("error")
          $(self.el).find(".js-new-crew-person-id").val("")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "crews/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Crew member removed.").show().fadeOut(window.hide_delay)
