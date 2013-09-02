class MoviesApp.AddToList extends Backbone.View
  template: JST['templates/lists/add_to_list']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"

  render: ->
    edit = $(@el)
    edit.html @template
    $(@el).find(".js-list").autocomplete
      source: api_version + "lists/search_my_lists"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(edit).find(".js-list-id").val(ui.item.id)
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
    else
      $(@el).find(".js-list").addClass("error")
