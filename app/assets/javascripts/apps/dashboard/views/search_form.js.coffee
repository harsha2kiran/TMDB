class DashboardApp.SearchForm extends Backbone.View
  template: JST['templates/dashboard/search_form']
  className: "dashboard-search row"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    search_form = $(@el)
    search_form.html @template
    $search = $(@el).find(".js-dashboard-search")

    $search.autocomplete
      source: api_version + "search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        if ui.item.type == "Movie"
          app = "movies"
        else if ui.item.type == "Person"
          app = "people"
        window.location = root_path + "/#!/" + app + "/" + ui.item.id
    this
