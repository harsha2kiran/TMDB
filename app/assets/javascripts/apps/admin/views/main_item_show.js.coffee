class AdminApp.MainItemShow extends Backbone.View
  template: JST['templates/admin/main_item_show']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-approve" : "approve"
    "click .js-update" : "update"
    "click .js-add-popular" : "popular"

  render: ->
    @show = $(@el)
    type = @options.type
    @id = @options.id
    @type = type
    items = @options.items
    @show.html @template(items: items, type: type)
    $(@show).find(".js-birthday, .js-day-of-death").datepicker(
      dateFormat: "yy-mm-dd"
    )
    this

  update: (e) ->
    console.log "update"
    self = @
    id = @id
    type = @type
    approved_id = $(e.target).parents(".box").find(".item-id").val()
    cont = $(e.target).parents(".box")
    if type == "Movie"
      title = cont.find(".js-title").val()
      overview = cont.find(".js-overview").val()
      tagline = cont.find(".js-tagline").val()
      content_score = cont.find(".js-content-score").val()
      data = { id: approved_id, movie: { title: title, overview: overview, tagline: tagline, content_score: content_score } }
      controller = "movies"
    else if type == "Person"
      biography = cont.find(".js-biography").val()
      homepage = cont.find(".js-homepage").val()
      birthday = cont.find(".js-birthday").val()
      place_of_birth = cont.find(".js-place-of-birth").val()
      day_of_death = cont.find(".js-day-of-death").val()
      imdb_id = cont.find(".js-imdb-id").val()
      data = { id: approved_id, person: { biography: biography, homepage: homepage, birthday: birthday, place_of_birth: place_of_birth, day_of_death: day_of_death, imdb_id: imdb_id } }
      controller = "people"
    if data
      $.ajax "#{api_version}#{controller}/#{approved_id}?temp_user_id=#{localStorage.temp_user_id}",
        method: "put"
        data: data
        success: ->
          $(".notifications").html("Item updated.").show().fadeOut(window.hide_delay)

  approve: (e) ->
    type = @type
    id = @id
    mark = $(e.target).attr("data-value")
    approved_id = $(e.target).parents(".box").find(".item-id").val()
    temp_user_id = $(e.target).attr("data-temp-user-id")
    user_id = $(e.target).attr("data-user-id")
    original_id = $(".approved[value='true']").prev().val()
    if !original_id
      original_id = approved_id
    if approved_id && original_id

      $.ajax api_version + "approvals/mark",
        method: "post"
        data:
          approved_id: approved_id
          original_id: original_id
          type: type
          mark: mark
        success: ->

          $.ajax api_version + "approvals/add_remove_main_pending",
            method: "post"
            data:
              original_id: original_id
              type: type
              user_id: user_id
              temp_user_id: temp_user_id
              mark: mark
            success: (response) ->
              console.log response

          items = new AdminApp.MainItems()
          items.url = api_version + "approvals/main_item"
          items.fetch
            data:
              id: id
              type: type
            success: ->
              @show_view = new AdminApp.MainItemShow(id: id, items: items, type: type)
              $(".js-content").html @show_view.render().el

          details = new AdminApp.MainItems()
          if type == "Movie"
            details.url = api_version + "movies/#{id}?moderate=true"
          else
            details.url = api_version + "people/#{id}?moderate=true"
          details.fetch
            success: ->
              @details_view = new AdminApp.ItemsIndex(items: details, type: type)
              $(".js-item-details").html @details_view.render().el
          $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  popular: (e) ->
    item = $(e.target)
    id = item.attr("data-id")
    type = item.attr("data-type")
    position = $(@el).find(".js-popular").val()
    if position == ""
      position = "0"
    if position == "0" || position == "0.0"
      text = type + " will be removed from home page gallery. Please confirm."
    else
      text = type + " will be visible in home page gallery. Please confirm."
    if confirm(text) == true
      item = new DashboardApp.GalleryModel()
      if type == "Movie"
        item.url = api_version + "movies/" + id
        item.save ({ id: id, movie: { id: id, popular: position } }),
          success: ->
            console.log "updated"
      else if type == "Person"
        item.url = api_version + "people/" + id
        item.save ({ id: id, person: { id: id, popular: position } }),
          success: ->
            console.log "updated"





