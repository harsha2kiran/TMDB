class PeopleApp.Edit extends Backbone.View
  template: JST['templates/people/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-update" : "update"

  render: ->
    edit = $(@el)
    person = @options.person
    edit.html @template(person: person)
    $(@el).find(".js-birthday, .js-day-of-death").datepicker(
      dateFormat: "yy-mm-dd"
    )
    this

  update: (e) ->
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
      person.save ({ person: { name: name, biography: biography, homepage: homepage, birthday: birthday, place_of_birth: place_of_birth, day_of_death: day_of_death, imdb_id: imdb_id, original_id: person_id } }),
        success: ->
          $(".notifications").html("Successfully updated person. Changes will be active after moderation.").show().fadeOut(10000)
          $container.find(".js-name").removeClass("error")
    else
      $container.find(".js-name").addClass("error")

