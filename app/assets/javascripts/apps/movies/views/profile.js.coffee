class MoviesApp.Profile extends Backbone.View
  template: JST['templates/user/profile']
  className: "movies-show row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-update" : "update"

  render: ->
    show = $(@el)
    show.html @template
    this

  update: (e) ->
    parent = $(@el)
    id = parent.find(".js-user-id").val()
    first_name = $.trim(parent.find(".js-first-name").val())
    last_name = $.trim(parent.find(".js-last-name").val())
    biography = $.trim(parent.find(".js-biography").val())
    user = new MoviesApp.User()
    user.set({ id: id, user: { id: id, first_name: first_name, last_name: last_name, biography: biography } })
    user.save null,
      success: ->
        $(".notifications").html("Profile successfully updated.").show().fadeOut(window.hide_delay)


