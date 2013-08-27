class AdminApp.Router extends Backbone.Router

  routes:
    "admin/movies" : "movies"
    "admin/people" : "people"
    "admin/movies/:id" : "movie"
    "admin/people/:id" : "person"

  initialize: ->
    @clear_values()
    console.log "AdminApp router initialized"

  movies: ->
    if current_user && current_user.user_type == "admin"
      console.log "admin movies index"
      @clear_values()
      movies = new MoviesApp.Movies()
      movies.fetch
        success: ->
          @index_view = new MoviesApp.Index(movies: movies, admin: true)
          $(".js-content").html @index_view.render().el

  people: ->
    if current_user && current_user.user_type == "admin"
      console.log "admin people index"
      people = new PeopleApp.People()
      people.fetch
        success: ->
          @index_view = new PeopleApp.Index(people: people, admin: true)
          $(".js-content").html @index_view.render().el

  movie: (id) ->
    if current_user && current_user.user_type == "admin"
      console.log "admin router show movie #{id}"
      @clear_values()
      window.movie_id = id
      movie = new MoviesApp.Movie()
      movie.url = "/api/v1/movies/#{id}"
      movie.fetch
        success: ->
          @show_view = new AdminApp.Movie(movie: movie)
          $(".js-content").html @show_view.render().el

          type = "Movie"
          id = window.movie_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type } }),
            success: ->
              console.log view

          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  person: (id) ->
    if current_user && current_user.user_type == "admin"
      console.log "admin router show person #{id}"
      @clear_values()
      window.person_id = id
      person = new PeopleApp.Person()
      person.url = "/api/v1/people/#{id}"
      person.fetch
        success: ->
          @show_view = new AdminApp.Person(person: person)
          $(".js-content").html @show_view.render().el

          type = "Person"
          id = window.person_id
          view = new MoviesApp.View()
          view.save ({ view: { viewable_id: id, viewable_type: type } }),
            success: ->
              console.log view
          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  clear_values: ->
    try
      delete window.person_id
    catch e
      window.person_id = undefined
    try
      delete window.movie_id
    catch e
      window.movie_id = undefined
    try
      delete window.list_id
    catch e
      window.list_id = undefined
