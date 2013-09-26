window.MoviesApp = {
  initialize: ->
    console.log "Movies app initialized"
    window.MoviesApp.router = new MoviesApp.Router()
    Backbone.history.start()

    $("body").on "click", ".lock", (e) ->
      self = $(@)
      field = $(@).attr("data-field")
      action = $(@).attr("data-action")
      item_id = 0
      item_type = ""
      if window.movie_id
        item_id = window.movie_id
        item_type = "Movie"
      else if window.person_id
        item_id = window.person_id
        item_type = "Person"

      if item_type != "" && item_id != ""
        lock = new MoviesApp.Lock()
        lock.url = api_version + "locks/" + action
        lock.save ({ field: field, item_id: item_id, item_type: item_type, temp_user_id: localStorage.temp_user_id }),
          success: (data) ->
            if action == "mark"
              self.prev().attr("readonly", "readonly")
              self.attr("data-action", "unmark")
              self.html "Unlock"
            else
              self.prev().removeAttr("readonly")
              self.attr("data-action", "mark")
              self.html "Lock"
      else
        alert "error"

}

