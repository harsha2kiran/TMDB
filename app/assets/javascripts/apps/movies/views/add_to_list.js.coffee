class MoviesApp.AddToList extends Backbone.View
  template: JST['templates/lists/add_to_list']
  className: "row"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    self = @
    @edit = $(@el)
    @edit.html @template
    $(@el).find(".js-list").autocomplete
      source: api_version + "lists/search_my_lists"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        if ui.item.id == "0"
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.add_new_item()
        $(self.el).find(".js-list-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-list").val()), "list")
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-list-id").val("")
        else
          self.edit.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: (e) ->
    self = @
    list_id = $(@el).find(".js-list-id").val()
    console.log $(@el).find(".js-list-id")
    if list_id
      if window.movie_id
        listable_id = window.movie_id
        listable_type = "Movie"
      else if window.person_id
        listable_id = window.person_id
        listable_type = "Person"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: list_id, listable_id: listable_id, listable_type: listable_type } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-list").val("").removeClass "error"
          $(self.el).find(".js-list-id").val("")
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("List item already exist.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-list").val("").removeClass "error"
          $(self.el).find(".js-list-id").val("")
    else
      $(@el).find(".js-list").addClass("error")

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-list").val()
    if value != ""
      model = new MoviesApp.List()
      model.save ({ list: { title: value } }),
        success: ->
          $(self.el).find(".js-list").val(value).removeClass "error"
          $(self.el).find(".js-list-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("List added.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-list").val("").removeClass "error"
          $(self.el).find(".js-list-id").val("")
          self.cancel()
    else
      @edit.find(".js-list").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


