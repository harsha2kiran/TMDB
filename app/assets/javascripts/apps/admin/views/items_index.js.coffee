class AdminApp.ItemsIndex extends Backbone.View
  template: JST['templates/admin/items_index']
  className: "row-fluid items-index"

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

    selectors = [".js-alternative-title-language"]
    urls = ["languages"]
    $.each selectors, (i, selector) ->
      self.init_autocomplete(container, selector, urls[i])
    this

  approve: (e) ->
    console.log "update"
    id = $(e.target).parents(".js-edit-item").first().find("#id")
    model = id.attr("data-model")
    model = model.charAt(0).toUpperCase() + model.slice(1)
    id = id.val()
    if $.trim($(e.target).html()) == "Approve"
      mark = true
    else
      mark = false
    $.ajax api_version + "approvals/mark",
      method: "post"
      data:
        approved_id: id
        type: model
        mark: mark
      success: ->
        if mark == true
          $(e.target).html "Unapprove"
        else
          $(e.target).html "Approve"

  update: (e) ->
    console.log "update"
    id = $(e.target).parents(".span12").first().find("#id")
    controller = id.attr("data-controller")
    model = id.attr("data-model")
    id = id.val()
    values = {}
    values[model] = @generate_values(e)
    model = new AdminApp.Item()
    model.url = api_version + controller + "/" + id
    model.set(values)
    model.save id: id,
      success: ->
        console.log model
        $(".notifications").html("Successfully updated item.").show().fadeOut(window.hide_delay)
      error: ->
        $(".notifications").html("Error while updating item.").show().fadeOut(window.hide_delay)

  remove: (e) ->
    console.log "remove"
    container = $(e.target).parents(".js-edit-item").first()
    id = container.find("#id")
    controller = id.attr("data-controller")
    id = id.val()
    if confirm("Remove item?") == true
      $.ajax api_version + controller + "/" + id,
        method: "DELETE"
        success: =>
          $(".notifications").html("Successfully removed item.").show().fadeOut(window.hide_delay)
          container.remove()

  generate_values: (e) ->
    parent = $(e.target).parents(".js-edit-item").first()
    values = {}
    $.each parent.find("input"), (i, item) ->
      if $(item).attr("id") && $(item).attr("id") != "id" && $(item).attr("id") != "controller" && $(item).attr("id") != "model"
        values[$(item).attr("id")] = $(item).val()
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
