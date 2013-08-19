class PeopleApp.Router extends Backbone.Router

  routes:
    "people" : "index"
    "people/new" : "new"
    "people/:id" : "show"
    "people/:id/edit" : "edit"

  initialize: ->
    console.log "PeopleApp router initialized"

  show: (id) ->
    console.log "people router show #{id}"
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    window.person_id = id
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{id}"
    person.fetch
      success: ->
        @show_view = new PeopleApp.Show(person: person)
        $(".js-content").html @show_view.render().el

  index: ->
    console.log "people index"
    people = new PeopleApp.People()
    people.fetch
      success: ->
        @index_view = new PeopleApp.Index(people: people)
        $(".js-content").html @index_view.render().el

  edit: (id) ->
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    console.log "people router edit #{id}"
    window.person_id = id
    person = new PeopleApp.Person()
    person.url = "/api/v1/people/#{id}"
    person.fetch
      success: ->
        person = person.get("person")

        @edit_view = new PeopleApp.Edit(person: person)
        $(".js-content").html @edit_view.render().el

        @edit_images_view = new MoviesApp.EditImages(images: person.images)
        $(".js-content").append @edit_images_view.render().el

        @edit_videos_view = new MoviesApp.EditVideos(videos: person.videos)
        $(".js-content").append @edit_videos_view.render().el

        @edit_casts_view = new MoviesApp.EditCasts(casts: person.casts)
        $(".js-content").append @edit_casts_view.render().el

        @edit_crews_view = new MoviesApp.EditCrews(crews: person.crews)
        $(".js-content").append @edit_crews_view.render().el

        @edit_alternative_names_view = new PeopleApp.EditAlternativeNames(alternative_names: person.alternative_names)
        $(".js-content").append @edit_alternative_names_view.render().el

        @edit_person_social_apps_view = new PeopleApp.EditPersonSocialApps(person_social_apps: person.person_social_apps)
        $(".js-content").append @edit_person_social_apps_view.render().el

        @edit_tags_view = new MoviesApp.EditTags(tags: person.tags)
        $(".js-content").append @edit_tags_view.render().el

  new: ->
    console.log "add new person"
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    @new_view = new PeopleApp.New()
    $(".js-content").html @new_view.render().el
