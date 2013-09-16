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
    locked = person.locked
    if locked.locked
      window.locked = eval(locked.locked)
    else
      window.locked = []
    edit.html @template(person: person, locked: window.locked)
    $(@el).find(".js-birthday, .js-day-of-death").datepicker(
      dateFormat: "yy-mm-dd"
    )

    @edit_images_view = new MoviesApp.EditImages(images: person.images)
    $(@el).find(".images").html @edit_images_view.render().el

    @edit_videos_view = new MoviesApp.EditVideos(videos: person.videos)
    $(@el).find(".videos").html @edit_videos_view.render().el

    @edit_casts_view = new MoviesApp.EditCasts(casts: person.casts)
    $(@el).find(".cast").html @edit_casts_view.render().el

    @edit_crews_view = new MoviesApp.EditCrews(crews: person.crews)
    $(@el).find(".crew").html @edit_crews_view.render().el

    @edit_alternative_names_view = new PeopleApp.EditAlternativeNames(alternative_names: person.alternative_names)
    $(@el).find(".alternative-names").html @edit_alternative_names_view.render().el

    @edit_person_social_apps_view = new PeopleApp.EditPersonSocialApps(person_social_apps: person.person_social_apps)
    $(@el).find(".person-social-apps").html @edit_person_social_apps_view.render().el

    @edit_tags_view = new MoviesApp.EditTags(tags: person.tags)
    $(@el).find(".tags").html @edit_tags_view.render().el

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
    original_id = $container.find(".js-original-id").val()
    approved = $container.find(".js-approved").val()
    if name != ""
      person = new PeopleApp.Person()
      if approved == "true"
        person.save ({ edit_page: true, person: { name: name, biography: biography, homepage: homepage, birthday: birthday, place_of_birth: place_of_birth, day_of_death: day_of_death, imdb_id: imdb_id, original_id: original_id, temp_user_id: localStorage.temp_user_id } }),
          success: ->
            $(".notifications").html("Successfully updated person. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
            $container.find(".js-name").removeClass("error")
            $(".show-person").attr("href", "#/people/#{person.id}")
      else
        person.url = api_version + "people/" + person_id
        person.save ({ id: person_id, person: { name: name, biography: biography, homepage: homepage, birthday: birthday, place_of_birth: place_of_birth, day_of_death: day_of_death, imdb_id: imdb_id, original_id: original_id, temp_user_id: localStorage.temp_user_id } }),
          success: ->
            $(".notifications").html("Successfully updated person. Changes will be active after moderation.").show().fadeOut(window.hide_delay)
            $container.find(".js-name").removeClass("error")
            $(".show-person").attr("href", "#/people/#{person.id}")

    else
      $container.find(".js-name").addClass("error")

