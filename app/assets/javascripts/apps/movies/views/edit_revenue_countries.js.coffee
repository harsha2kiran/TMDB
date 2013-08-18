class MoviesApp.EditRevenueCountries extends Backbone.View
  template: JST['templates/revenue_countries/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-revenue-country-save" : "create"
    "click .js-revenue-country-remove" : "destroy"

  render: ->
    edit = $(@el)
    revenue_countries = @options.revenue_countries
    edit.html @template(revenue_countries: revenue_countries)

    self = @
    $(@el).find(".js-new-revenue-country").autocomplete
      source: api_version + "countries/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-revenue-country-id").val(ui.item.id)

    this

  create: (e) ->
    self = @
    country_id = $(@el).find(".js-new-revenue-country-id").val()
    revenue = $(@el).find(".js-new-revenue").val()
    if country_id != "" && revenue != ""
      revenue_country = new MoviesApp.RevenueCountry()
      revenue_country.save ({ revenue_country: { country_id: country_id, movie_id: movie_id, revenue: revenue } }),
        success: ->
          $(".notifications").html("Revenue country added. It will be active after moderation.").show().fadeOut(10000)
          $(self.el).find(".js-new-revenue-country").val("").removeClass("error")
          $(self.el).find(".js-new-revenue-country-id").val("")
          $(self.el).find(".js-new-revenue").val("").removeClass("error")
    else
      $(@el).find("input").each (i, input) ->
        if $(input).val() == ""
          $(input).addClass("error")
        else
          $(input).removeClass("error")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "revenue_countries/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Revenue country removed.").show().fadeOut(10000)
