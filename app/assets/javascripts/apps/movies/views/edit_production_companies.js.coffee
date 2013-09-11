class MoviesApp.EditProductionCompanies extends Backbone.View
  template: JST['templates/production_companies/edit']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-new-production-company-save" : "create"
    "click .js-production-company-remove" : "destroy"
    "click .js-new-item-add-yes" : "add_new_item"
    "click .js-new-item-add-no" : "cancel"

  render: ->
    @edit = $(@el)
    production_companies = @options.production_companies
    @edit.html @template(production_companies: production_companies)

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
        self.cancel()
      response: (event, ui) ->
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-production-company-id").val("")
    this

  create: (e) ->
    self = @
    company_id = $(@el).find(".js-new-production-company-id").val()
    production_company = new MoviesApp.ProductionCompany()
    if company_id != ""
      production_company.save ({ production_company: { company_id: company_id, movie_id: movie_id } }),
        success: ->
          $(".notifications").html("Production company added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val("").removeClass("error")
          $(self.el).find(".js-new-production-company-id").val("")
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Production company added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val("").removeClass "error"
          $(self.el).find(".js-new-production-company-id").val("")
    else
      $(self.el).find(".js-new-production-company").addClass("error").focus()

  destroy: (e) ->
    container = $(e.target).parents(".span12").first()
    id = $(e.target).attr("data-id")
    $.ajax api_version + "production_companies/" + id,
      method: "DELETE"
      success: =>
        container.remove()
        $(".notifications").html("Production company removed.").show().fadeOut(window.hide_delay)

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-production-company").val()
    if value != ""
      model = new MoviesApp.Company()
      model.save ({ company: { company: value } }),
        success: ->
          $(self.el).find(".js-new-production-company").val(value).removeClass "error"
          $(self.el).find(".js-new-production-company-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Company added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val("").removeClass "error"
          $(self.el).find(".js-new-production-company-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-production-company").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


