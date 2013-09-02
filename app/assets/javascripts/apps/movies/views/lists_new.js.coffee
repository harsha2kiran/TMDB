class MoviesApp.ListsNew extends Backbone.View
  template: JST['templates/lists/new']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"

  render: ->
    edit = $(@el)
    list_type = @options.list_type
    edit.html @template(list_type: list_type)
    this

  create: (e) ->
    $container = $(@el)
    title = $container.find(".js-title").val()
    list_type = $container.find(".js-list-type").val()
    description = $container.find(".js-description").val()
    if title != "" && description != ""
      list = new MoviesApp.List()
      list.save ({ list: { title: title, description: description, list_type: list_type } }),
        success: ->
          $(".notifications").html("Successfully added new list.").show().fadeOut(window.hide_delay)
          $container.find(".js-title").removeClass("error").val("")
          $container.find(".js-description").removeClass("error").val("")
          window.MoviesApp.router.navigate("#lists/#{list.id}", true)
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")


