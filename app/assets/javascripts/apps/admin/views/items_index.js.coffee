class AdminApp.ItemsIndex extends Backbone.View
  template: JST['templates/admin/items_index']
  className: "row items-index"

  events:
    "click .js-update" : "update"
    "click .js-remove" : "remove"
    "click .js-approve" : "approve"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    container = $(@el)
    items = @options.items
    type = @options.type
    container.html @template(items: items, type: type)
    self = @

    selectors = [".js-alternative-title-language", ".js-metadata-status", ".js-crew-person", ".js-cast-person", ".js-genre", ".js-language", ".js-country", ".js-tag-people", ".js-release-country", ".js-crew-movie", ".js-cast-movie", ".js-social-app", ".js-tag-movie"]
    urls = ["languages", "statuses", "people", "people", "genres", "language", "countries", "people", "countries", "movies", "movies", "social_apps", "movies"]
    $.each selectors, (i, selector) ->
      self.init_autocomplete(container, selector, urls[i])
    self.init_datepicker()
    this

  approve: (e) ->
    self = @
    console.log "approve"
    parent = $(e.target).parents(".js-edit-item").first()
    id = $(e.target).parents(".js-edit-item").first().children()
    model = id.attr("data-model")
    id = id.val()
    if $.trim($(e.target).html()) == "Approve"
      mark = true
    else
      mark = false

    pendable_id = $(".js-main-item").attr("data-id")
    pendable_type = $(".js-main-item").attr("data-type")
    approvable_id = id
    approvable_type = model
    additional_id = parent.find(".js-additional").attr("data-id")
    additional_type = parent.find(".js-additional").attr("data-type")
    user_id = parent.find(".js-user-temp-id").attr("data-user-id")
    temp_user_id = parent.find(".js-user-temp-id").attr("data-temp-user-id")

    $.ajax api_version + "approvals/mark",
      method: "post"
      data:
        approved_id: id
        type: model
        mark: mark
      success: ->
        if mark
          approval_type = "approve"
          $(e.target).html "Unapprove"
        else
          approval_type = "unapprove"
          $(e.target).html "Approve"
        self.send_add_remove_pending(pendable_id, pendable_type, user_id, temp_user_id, approvable_id, approvable_type, approval_type, additional_id, additional_type)

  send_add_remove_pending: (pendable_id, pendable_type, user_id, temp_user_id, approvable_id, approvable_type, approval_type, additional_id ="", additional_type = "") ->
    $.ajax api_version + "approvals/add_remove_pending",
      method: "post"
      data:
        pendable_id: pendable_id
        pendable_type: pendable_type
        user_id: user_id
        temp_user_id: temp_user_id
        approvable_id: approvable_id
        approvable_type: approvable_type
        approval_type: approval_type
        additional_id: additional_id
        additional_type: additional_type
      success: (response) ->
        console.log response

  update: (e) ->
    console.log "update"
    id = $(e.target).parents(".js-edit-item").first().children()
    controller = id.attr("data-controller")
    key = id.attr("data-key")
    id = id.val()
    values = {}
    values[key] = @generate_values(e)
    model = new AdminApp.Item()
    model.url = api_version + controller + "/" + id
    model.set(values)
    model.save id: id,
      success: ->
        $(".notifications").html("Successfully updated item.").show().fadeOut(window.hide_delay)
      error: ->
        $(".notifications").html("Error while updating item.").show().fadeOut(window.hide_delay)

  remove: (e) ->
    self = @
    console.log "remove"
    container = $(e.target).parents(".js-edit-item").first()
    id = container.children()
    controller = id.attr("data-controller")
    model = id.attr("data-model")
    id = id.val()
    if confirm("Remove item?") == true
      $.ajax api_version + controller + "/" + id,
        method: "DELETE"
        success: =>
          pendable_id = $(".js-main-item").attr("data-id")
          pendable_type = $(".js-main-item").attr("data-type")
          approvable_id = id
          approvable_type = model
          user_id = container.find(".js-user-temp-id").attr("data-user-id")
          temp_user_id = container.find(".js-user-temp-id").attr("data-temp-user-id")
          approval_type = "approve"
          self.send_add_remove_pending(pendable_id, pendable_type, user_id, temp_user_id, approvable_id, approvable_type, approval_type)
          $(".notifications").html("Successfully removed item.").show().fadeOut(window.hide_delay)
          container.remove()

  generate_values: (e) ->
    parent = $(e.target).parents(".js-edit-item").first()
    values = {}
    $.each parent.find("input, select"), (i, item) ->
      if $(item).attr("data-id") && $(item).attr("data-id") != "id"
        values[$(item).attr("data-id")] = $(item).val()
    values

  init_autocomplete: (container, selector, url) ->
    container.find(selector).autocomplete
      source: api_version + url + "/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        container.find(selector).next().val(ui.item.id)
      response: (event, ui) ->
        if ui.content.length == 0
          container.find(selector).next().val("")

  init_datepicker: ->
    $(@el).find(".js-datepicker").datepicker(
      dateFormat: "yy-mm-dd"
    )

