class MoviesApp.EditProductionCompanies extends Backbone.View
  template: JST['templates/production_companies/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-production-company-save" : "create"
    "click .js-production-company-remove" : "destroy"

  render: ->
    edit = $(@el)
    production_companies = @options.production_companies
    edit.html @template(production_companies: production_companies)

    self = @
    $(@el).find(".js-new-production-company").autocomplete
      source: api_version + "companies/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(self.el).find(".js-new-production-company-id").val(ui.item.id)

    this

  create: (e) ->
    self = @
    company_id = $(@el).find(".js-new-production-company-id").val()
    production_company = new MoviesApp.ProductionCompany()
    production_company.save ({ production_company: { company_id: company_id, movie_id: movie_id } }),
      success: ->
        $(".notifications").html("Production company added. It will be active after moderation.").show().fadeOut(10000)
        $(self.el).find(".js-new-production-company").val("")

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "production_companies/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Production company removed.").show().fadeOut(10000)
