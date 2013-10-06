class MoviesApp.EditSingleImage extends Backbone.View
  template: JST['templates/images/edit_single_image']
  className: "row-fluid edit-single-image"

  events:
    "click .js-drop-image-update" : "update"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    edit = $(@el)
    @edit = $(@el)
    @image = @options.image
    edit.html @template(image: @image)
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
          edit.find(".keyword").each ->
            keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
            keyword_ids.push parseInt($(@).attr("data-id"))
          if $.inArray(parseInt(ui.item.id), keyword_ids) == -1
            keyword_ids.push ui.item.id
            keywords.push [ui.item.id, ui.item.label]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          edit.find(".js-keywords-list").html @keywords_view.render().el
        $(".ui-autocomplete-input").val("")
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-image-keyword").val()), "keyword")
        if ui.content.length == 0
          edit.find(".js-new-item-info, .js-new-item-add-form").show()
          edit.find(".js-new-image-keyword-id").val("")
        else
          edit.find(".js-new-item-info, .js-new-item-add-form").hide()

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
            tags_list_el = ".js-tags-movies-list"
          else if ui.item.type == "Person"
            tags_list_el = ".js-tags-people-list"
          else if ui.item.type == "Company"
            tags_list_el = ".js-tags-companies-list"
          tags_list = edit.find(tags_list_el).find(".tag")
          tags_list.each ->
            tags.push [$(@).attr("data-id"), $(@).attr("data-type"), $.trim($(@).find(".tag-tag").html())]
            tag_ids.push parseInt($(@).attr("data-id"))
          if $.inArray(parseInt(ui.item.id), tag_ids) == -1
            tag_ids.push ui.item.id
            tags.push [ui.item.id, ui.item.type, ui.item.label]
          @tags_view = new MoviesApp.Tags(tags: tags)
          edit.find(tags_list_el).html @tags_view.render().el
        $(".ui-autocomplete-input").val("")
      # response: (event, ui) ->
      #   ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-tag-person").val()), "person")
      #   if ui.content.length == 0
      #     $(self.el).find(".js-new-person-info, .js-new-person-add-form").show()
      #     $(self.el).find(".js-new-person-id").val("")
      #   else
      #     self.edit.find(".js-new-person-info, .js-new-person-add-form").hide()
    this

  update: (e) ->
    console.log "update"
    self = @
    container = $(e.target).parent()
    title = $(@el).find(".js-drop-image-title").val()
    description = $(@el).find(".js-drop-image-description").val()
    if title != "" && window.list_id
      image = new MoviesApp.Image()
      imageable_id = window.list_id
      imageable_type = "List"
      image.save ({ id: @image.id, image: { id: @image.id, description: description, title: title, imageable_id: imageable_id, imageable_type: imageable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          if window.list_id
            self.add_image_to_list(image.id)
            self.add_keywords_to_image(image.id)
            self.add_tags_to_image(image.id)
          $(".notifications").html("Image added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(container).remove()
          self.reload_list_items()
    else
      $(@el).find(".js-drop-image-title").addClass("error").focus()

  add_keywords_to_image: (image_id) ->
    console.log "add keywords to image"
    edit = $(@el)
    keyword_ids = []
    if edit.find(".keyword").length > 0
      edit.find(".keyword").each ->
        keyword_ids.push parseInt($(@).attr("data-id"))
      media_keyword = new MoviesApp.MediaKeyword()
      media_keyword.save ({ keyword_ids: keyword_ids, mediable_id: image_id, mediable_type: "Image", temp_user_id: localStorage.temp_user_id }),
        success: ->
          if keyword_ids.length == 1
            $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          else
            $(".notifications").html("Keywords added. They will be active after moderation.").show().fadeOut(window.hide_delay)

  add_tags_to_image: (image_id) ->
    console.log "add tags to image"
    edit = $(@el)
    tag_types = []
    tag_ids = []
    tags_list = edit.find(".tag")
    if tags_list.length > 0
      tags_list.each ->
        tag_types.push $(@).attr("data-type")
        tag_ids.push parseInt($(@).attr("data-id"))
      media_tag = new MoviesApp.MediaTag()
      media_tag.save ({ tag_types: tag_types, tag_ids: tag_ids, mediable_id: image_id, mediable_type: "Image", temp_user_id: localStorage.temp_user_id }),
        success: ->
          if tag_ids.length == 1
            $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          else
            $(".notifications").html("Tags added. It will be active after moderation.").show().fadeOut(window.hide_delay)


  add_image_to_list: (image_id) ->
    self = @
    if window.list_id
      listable_id = @image.id
      listable_type = "Image"
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: localStorage.temp_user_id } }),
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)

  reload_list_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el
          if $(".dropped-image").length == 0
            $(".div-dropped-save-all").remove()

  add_new_item: (e) ->
    self = @
    value = @edit.find(".js-new-image-keyword").val()
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
          $(".js-keywords-list").html @keywords_view.render().el
        error: (model, response) ->
          $(".notifications").html("Keyword is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-image-keyword-id").val("")
    else
      @edit.find(".js-new-image-keyword").addClass("error")

  # create: (e) ->
  #   self = @
  #   keyword_id = $(@el).find(".js-new-image-keyword-id").val()
  #   last_image_id = 0
  #   if keyword_id != ""
  #     media_keyword = new MoviesApp.MediaKeyword()
  #     media_keyword.save ({ media_keyword: { keyword_id: keyword_id, mediable_id: last_image_id, mediable_type: "Image", temp_user_id: localStorage.temp_user_id } }),
  #       success: ->
  #         $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
  #         # self.reload_items()
  #       error: (model, response) ->
  #         console.log "error"
  #         $(".notifications").html("Keyword already exist or it's waiting for moderation.").show().fadeOut(window.hide_delay)
  #         $(self.el).find(".js-new-image-keyword").val("").removeClass "error"
  #         $(self.el).find(".js-new-image-keyword-id").val("")
  #   else
  #     $(@el).find(".js-new-image-keyword").addClass("error").focus()

