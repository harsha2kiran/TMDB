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
        if ui.item.id == "0"
          self.add_new_item()
        $(self.el).find(".js-new-production-company-id").val(ui.item.id)
        self.cancel()
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-production-company").val()), "company")
        if ui.content.length == 0
          self.edit.find(".js-new-item-info, .js-new-item-add-form").show()
          self.edit.find(".js-new-production-company-id").val("")
        else
          self.edit.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: (e) ->
    self = @
    company_id = $(@el).find(".js-new-production-company-id").val()
    production_company = new MoviesApp.ProductionCompany()
    if company_id != ""
      production_company.save ({ production_company: { company_id: company_id, movie_id: movie_id, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Production company added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          self.reload_items()
        error: (model, response) ->
          console.log "error"
          $(".notifications").html("Production company  already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val("").removeClass "error"
          $(self.el).find(".js-new-production-company-id").val("")
    else
      $(self.el).find(".js-new-production-company").addClass("error").focus()

  reload_items: ->
    movie = new MoviesApp.Movie()
    movie.url = "/api/v1/movies/#{window.movie_id}/my_movie"
    movie.fetch
      data:
        temp_user_id: localStorage.temp_user_id
      success: =>
        movie = movie.get("movie")
        $(@el).remove()
        @stopListening()
        @edit_production_companies_view = new MoviesApp.EditProductionCompanies(production_companies: movie.production_companies)
        $(".production-companies").html @edit_production_companies_view.render().el

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
          $(".notifications").html("Company added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val(value).removeClass "error"
          $(self.el).find(".js-new-production-company-id").val(model.id)
          self.create()
          self.cancel()
        error: (model, response) ->
          $(".notifications").html("Company is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-production-company").val("").removeClass "error"
          $(self.el).find(".js-new-production-company-id").val("")
          self.cancel()
    else
      @edit.find(".js-new-production-company").addClass("error")

  cancel: ->
    @edit.find(".js-new-item-info, .js-new-item-add-form").hide()


