class PeopleApp.New extends Backbone.View
  template: JST['templates/people/new']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"

  render: ->
    edit = $(@el)
    edit.html @template
    $(@el).find(".js-birthday, .js-day-of-death").datepicker(
      dateFormat: "yy-mm-dd"
    )
    this

  create: (e) ->
    $container = $(e.target).parents(".person")
    name = $container.find(".js-name").val()
    biography = $container.find(".js-biography").val()
    homepage = $container.find(".js-homepage").val()
    birthday = $container.find(".js-birthday").val()
    place_of_birth = $container.find(".js-place-of-birth").val()
    day_of_death = $container.find(".js-day-of-death").val()
    imdb_id = $container.find(".js-imdb-id").val()
    if name != ""
      person = new PeopleApp.Person()
      person.save ({ person: { name: name, biography: biography, homepage: homepage, birthday: birthday, place_of_birth: place_of_birth, day_of_death: day_of_death, imdb_id: imdb_id, temp_user_id: localStorage.temp_user_id } }),
        error: ->
          $(".notifications").html("Person already exist.").show().fadeOut(window.hide_delay)
          $container.find(".js-name").addClass("error")
        success: ->
          $(".notifications").html("Successfully added new person. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
          $container.find(".js-name").removeClass("error")
          window.PeopleApp.router.navigate("#people/#{person.id}", true)
    else
      $container.find(".js-name").addClass("error")


