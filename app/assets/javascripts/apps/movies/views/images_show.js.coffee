class MoviesApp.ImagesShow extends Backbone.View
  template: JST['templates/images/show']
  className: "row-fluid"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    show = $(@el)
    @show = $(@el)
    image = @options.image.get("image")
    show.html @template(image: image)
    keywords = []
    $(@el).find(".js-new-image-keyword").autocomplete
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
          show.find(".keyword").each ->
            keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
            keyword_ids.push parseInt($(@).attr("data-id"))
          if $.inArray(parseInt(ui.item.id), keyword_ids) == -1
            keyword_ids.push ui.item.id
            keywords.push [ui.item.id, ui.item.label]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          show.find(".js-keywords-image").html @keywords_view.render().el
        $(".ui-autocomplete-input").val("")
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-image-keyword").val()), "keyword")
        if ui.content.length == 0
          show.find(".js-new-item-info, .js-new-item-add-form").show()
          show.find(".js-new-image-keyword-id").val("")
        else
          show.find(".js-new-item-info, .js-new-item-add-form").hide()

    $(@el).find(".js-new-image-tag").autocomplete
      source: api_version + "tags/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        if ui.item.id == "0"
          self.add_new_tag(ui.item.type)
        else
          tags = []
          tag_ids = []
          if ui.item.type == "Movie"
            tags_list_el = ".js-tags-movies-image"
          else if ui.item.type == "Person"
            tags_list_el = ".js-tags-people-image"
          else if ui.item.type == "Company"
            tags_list_el = ".js-tags-companies-image"
          tags_list = show.find(tags_list_el).find(".tag")
          tags_list.each ->
            tags.push [$(@).attr("data-id"), $(@).attr("data-type"), $.trim($(@).find(".tag-tag").html())]
            tag_ids.push parseInt($(@).attr("data-id"))
          if $.inArray(parseInt(ui.item.id), tag_ids) == -1
            tag_ids.push ui.item.id
            tags.push [ui.item.id, ui.item.type, ui.item.label]
          @tags_view = new MoviesApp.Tags(tags: tags)
          show.find(tags_list_el).html @tags_view.render().el
        $(".ui-autocomplete-input").val("")
    this

  add_new_item: (e) ->
    self = @
    value = @show.find(".js-new-image-keyword").val()
    if value != ""
      model = new MoviesApp.Keyword()
      model.save ({ keyword: { keyword: value } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val("")
          keywords = []
          keyword_ids = []
          self.edit.find(".keyword").each ->
            keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
            keyword_ids.push $(@).attr("data-id")
          if $.inArray(model.id, keyword_ids) == -1
            keyword_ids.push model.id
            keywords.push [model.id, model.get("keyword")]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          $(".js-keywords-image").html @keywords_view.render().el
        error: (model, response) ->
          $(".notifications").html("Keyword is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val("")
    else
      @show.find(".js-new-image-keyword").addClass("error")
