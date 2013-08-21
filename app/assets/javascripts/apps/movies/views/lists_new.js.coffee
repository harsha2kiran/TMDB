class MoviesApp.ListsNew extends Backbone.View
  template: JST['templates/lists/new']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"

  render: ->
    edit = $(@el)
    edit.html @template
    this

  create: (e) ->
    $container = $(@el)
    title = $container.find(".js-title").val()
    description = $container.find(".js-description").val()
    if title != "" && description != ""
      list = new MoviesApp.List()
      list.save ({ list: { title: title, description: description } }),
        success: ->
          $(".notifications").html("Successfully added new list.").show().fadeOut(10000)
          $container.find(".js-title").removeClass("error").val("")
          $container.find(".js-description").removeClass("error").val("")
          window.MoviesApp.router.navigate("#lists/#{list.id}", true)
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")


