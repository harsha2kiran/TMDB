class MoviesApp.SingleImageKeywords extends Backbone.View
  template: JST['templates/keywords/edit_single_image_keywords']
  className: "row edit-single-image-keywords"

  events:
    "click .js-remove-keyword" : "remove_keyword"
    "click .js-approve-keyword" : "approve_keyword"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    @container = $(@el)
    item = @options.item
    @container.html @template(item: item)
    @init_keywords_autocomplete()
    this

  init_keywords_autocomplete: ->
    self = @
    keywords = []
    $(@el).find(".js-new-keyword").autocomplete
      source: api_version + "keywords/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        if ui.item.id == "0"
          self.add_new_item()
        else
          keywords = []
          keyword_ids = []
          # self.container.find(".keyword").each ->
          #   keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
          #   keyword_ids.push parseInt($(@).attr("data-id"))
          # if $.inArray(parseInt(ui.item.id), keyword_ids) == -1
          keyword_ids.push ui.item.id
          keywords.push [ui.item.id, ui.item.label]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          self.container.find(".js-keywords-list").append @keywords_view.render().el
        $(@).val("")
        return false
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-keyword").val()), "keyword")
        if ui.content.length == 0
          self.container.find(".js-new-item-info, .js-new-item-add-form").show()
          self.container.find(".js-new-keyword-id").val("")
        else
          self.container.find(".js-new-item-info, .js-new-item-add-form").hide()

  add_new_item: (e) ->
    self = @
    value = @container.find(".js-new-keyword").val()
    if value != ""
      model = new MoviesApp.Keyword()
      model.save ({ keyword: { keyword: value } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-keyword-id").val("")
          keywords = []
          keyword_ids = []
          # self.container.find(".keyword").each ->
          #   keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
          #   keyword_ids.push $(@).attr("data-id")
          # if $.inArray(model.id, keyword_ids) == -1
          keyword_ids.push model.id
          keywords.push [model.id, model.get("keyword")]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          $(".js-keywords-list").append @keywords_view.render().el
        error: (model, response) ->
          $(".notifications").html("Keyword is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-keyword-id").val("")
    else
      @container.find(".js-new-keyword").addClass("error")

  remove_keyword: (e) ->
    parent = $(e.target).parents(".keyword").first()
    id = parent.attr("data-id")
    $.ajax api_version + "media_keywords/test",
      method: "DELETE"
      data:
        mediable_id: window.image_id
        mediable_type: "Image"
        keyword_id: id
      success: ->
        parent.remove()
        $(".notifications").html("Keyword successfully removed.").show().fadeOut(window.hide_delay)

  approve_keyword: (e) ->
    parent = $(e.target).parents(".keyword").first()
    id = parent.attr("data-id")
    list_keyword = new MoviesApp.MediaKeyword()
    list_keyword.save ({ id: "0", media_keyword: {  mediable_id: window.image_id, mediable_type: "Image", keyword_id: id, approved: true } }),
      success: ->
        parent.find(".js-approve-keyword").remove()
        $(".notifications").html("Keyword successfully approved.").show().fadeOut(window.hide_delay)
