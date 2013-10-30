class MoviesApp.ListsShow extends Backbone.View
  template: JST['templates/lists/show']
  className: "row show-lists"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-create" : "create"
    "click .follow" : "follow"
    "click .following" : "unfollow"
    "click .js-update-keywords-tags" : "update_keywords_tags"
    "click .js-remove-keyword" : "remove_keyword"
    "click .js-remove-tag" : "remove_tag"
    "click .js-approve-keyword" : "approve_keyword"
    "click .js-approve-tag" : "approve_tag"
    "click .js-approve-list" : "approve_list"
    "click .js-unapprove-list" : "unapprove_list"

  render: ->
    show = $(@el)
    self = @
    list = @options.list.get("list")
    show.html @template(list: list)
    @show = $(@el)

    $(@el).find(".js-item").autocomplete
      source: api_version + "search?for_list=true"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        $(show).find(".js-item-type").val(ui.item.type)
        $(show).find(".js-item-id").val(ui.item.id)

    keywords = []
    $(@el).find(".js-new-list-keyword").autocomplete
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
          found = false
          $(self.el).find(".js-keywords-list .keyword-keyword").each ->
            if $.trim($(@).html()) == ui.item.label
              found = true
          if found
            $(".notifications").html("Keyword already added.").show().fadeOut(window.hide_delay)
            $(@).val("")
          else
            keywords = []
            keyword_ids = []
            # show.find(".keyword").each ->
            #   keywords.push [$(@).attr("data-id"), $.trim($(@).find(".keyword-keyword").html())]
            #   keyword_ids.push parseInt($(@).attr("data-id"))
            # if $.inArray(parseInt(ui.item.id), keyword_ids) == -1
            keyword_ids.push ui.item.id
            keywords.push [ui.item.id, ui.item.label]
            @keywords_view = new MoviesApp.Keywords(keywords: keywords)
            show.find(".js-keywords-list").append @keywords_view.render().el
        $(@).val("")
        return false
      response: (event, ui) ->
        ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-list-keyword").val()), "keyword")
        if ui.content.length == 0
          show.find(".js-new-item-info, .js-new-item-add-form").show()
          show.find(".js-new-list-keyword-id").val("")
        else
          show.find(".js-new-item-info, .js-new-item-add-form").hide()

    $(@el).find(".js-new-list-tag").autocomplete
      source: api_version + "tags/search"
      minLength: 2
      messages:
        noResults: ''
        results: ->
          ''
      select: (event, ui) ->
        found = false
        if ui.item.id == "-1"
          type = "Movie"
          self.add_new_tag(type)
        else if ui.item.id == "-2"
          type = "Person"
          self.add_new_tag(type)
        else if ui.item.id == "-3"
          type = "Company"
          self.add_new_tag(type)
        else
          tags = []
          tag_ids = []
          if ui.item.type == "Movie"
            tags_list_el = ".js-tags-movies-list"
          else if ui.item.type == "Person"
            tags_list_el = ".js-tags-people-list"
          else if ui.item.type == "Company"
            tags_list_el = ".js-tags-companies-list"
          tags_list = $(".list-tags").find(tags_list_el).find(".tag")
          $(self.el).find(tags_list_el + " .tag-tag").each ->
            if $.trim($(@).html()) == ui.item.label
              found = true
          if found
            $(".notifications").html("Tag already added.").show().fadeOut(window.hide_delay)
            $(@).val("")
          else
            tag_ids.push ui.item.id
            tags.push [ui.item.id, ui.item.type, ui.item.value]
            @tags_view = new MoviesApp.Tags(tags: tags)
            show.find(tags_list_el).append @tags_view.render().el
        $(@).val("")
        return false
      response: (event, ui) ->
        ui.content = window.check_tags_autocomplete(ui.content, $.trim($(".js-new-list-tag").val()))
        if ui.content.length == 0
          show.find(".js-new-item-info, .js-new-item-add-form").show()
          show.find(".js-new-list-tag-id").val("")
        else
          show.find(".js-new-item-info, .js-new-item-add-form").hide()
    this

  create: ->
    self = @
    item_id = $(@el).find(".js-item-id").val()
    item_type = $(@el).find(".js-item-type").val()
    if item_id != "" && item_type != ""
      listable_id = item_id
      listable_type = item_type
      list_item = new MoviesApp.ListItem()
      list_item.save ({ list_item: { list_id: window.list_id, listable_id: listable_id, listable_type: listable_type, temp_user_id: localStorage.temp_user_id } }),
        error: ->
          $(".notifications").html("Cannot add this item to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-item").val("").removeClass "error"
        success: ->
          $(".notifications").html("Successfully added to list.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-item").val("").removeClass "error"
          $(self.el).find(".js-item-id").val("")
          self.reload_list_items()
    else
      $(@el).find(".js-item").addClass("error")

  reload_list_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          @show_list_items_view = new MoviesApp.ListItemsShow(list: list)
          $(".list_items").html @show_list_items_view.render().el

  follow: (e) ->
    $self = $(e.target)
    type = "List"
    id = window.list_id
    follow = new MoviesApp.Follow()
    follow.save ({ follow: { followable_id: id, followable_type: type } }),
      success: ->
        $self.addClass("following").removeClass("follow").html("Already following")

  unfollow: (e) ->
    $self = $(e.target)
    type = "List"
    id = window.list_id
    $.ajax api_version + "follows/test",
      method: "DELETE"
      data:
        followable_id: id
        followable_type: type
      success: =>
        $self.addClass("follow").removeClass("following").html("Follow")

  add_new_item: (e) ->
    self = @
    value = @show.find(".js-new-list-keyword").val()
    if value != ""
      model = new MoviesApp.Keyword()
      model.save ({ keyword: { keyword: value } }),
        success: ->
          $(".notifications").html("Keyword added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-list-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-list-keyword-id").val("")
          keywords = []
          keyword_ids = []
          keyword_ids.push model.id
          keywords.push [model.id, model.get("keyword")]
          @keywords_view = new MoviesApp.Keywords(keywords: keywords)
          $(".js-keywords-list").append @keywords_view.render().el
        error: (model, response) ->
          $(".notifications").html("Keyword is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-list-keyword").val("").removeClass "error"
          $(self.el).find(".js-new-list-keyword-id").val("")
    else
      @show.find(".js-new-list-keyword").addClass("error")

  add_new_tag: (type) ->
    self = @
    value = @show.find(".js-new-list-tag").val()
    if value != ""
      model = ""
      if type == "Movie"
        model = new MoviesApp.Movie()
        model.url = "/api/v1/movies?temp_user_id=" + localStorage.temp_user_id
        model.set({ movie: { title: value } })
      else if type == "Person"
        model = new PeopleApp.Person()
        model.url = "/api/v1/people?temp_user_id=" + localStorage.temp_user_id
        model.set({ person: { name: value } })
      else if type == "Company"
        model = new MoviesApp.Company()
        model.url = "/api/v1/companies"
        model.set({ company: { company: value } })
      model.save null,
        success: ->
          $(".notifications").html("Tag added. It will be active after moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-list-tag").val("").removeClass "error"
          $(self.el).find(".js-new-list-tag-id").val("")
          tags = []
          tag_ids = []
          value = ""
          if type == "Movie"
            tags_list_el = ".js-tags-movies-list"
            value = model.get("title")
          else if type == "Person"
            tags_list_el = ".js-tags-people-list"
            value = model.get("name")
          else if type == "Company"
            tags_list_el = ".js-tags-companies-list"
            value = model.get("company")
          tags_list = $(".list-tags").find(tags_list_el).find(".tag")
          tag_ids.push model.id
          tags.push [model.id, type, value]
          @tags_view = new MoviesApp.Tags(tags: tags)
          self.show.find(tags_list_el).append @tags_view.render().el

        error: (model, response) ->
          $(".notifications").html("Tag is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-list-tag").val("").removeClass "error"
          $(self.el).find(".js-new-list-tag-id").val("")
    else
      @show.find(".js-new-list-tag").addClass("error")

  update_keywords_tags: (e) ->
    self = @
    keyword_ids = []
    if $(".list-keywords").find(".keyword").length > 0
      $(".list-keywords").find(".keyword").each ->
        keyword_ids.push parseInt($(@).attr("data-id"))

      list_keyword = new MoviesApp.ListKeyword()
      list_keyword.save ({ keyword_ids: keyword_ids, listable_id: window.list_id, listable_type: window.list_type, temp_user_id: localStorage.temp_user_id }),
        success: ->
          console.log "keywords success"
          $(".notifications").html("Changes successfully saved.").show().fadeOut(window.hide_delay)
          if $(".list-tags").find(".tag").length == 0
            self.reload_main_items()

    tag_ids = []
    tag_types = []
    if $(".list-tags").find(".tag").length > 0
      tags_list = $(".list-tags").find(".tag")
      if tags_list.length > 0
        tags_list.each ->
          tag_types.push $(@).attr("data-type")
          tag_ids.push parseInt($(@).attr("data-id"))
        list_tag = new MoviesApp.ListTag()
        list_tag.save ({ tag_types: tag_types, tag_ids: tag_ids, listable_id: window.list_id, listable_type: window.list_type, temp_user_id: localStorage.temp_user_id }),
          success: ->
            console.log "tag success"
            $(".notifications").html("Changes successfully saved.").show().fadeOut(window.hide_delay)
            self.reload_main_items()

  reload_main_items: ->
    list = new MoviesApp.List()
    list.url = "/api/v1/lists/#{window.list_id}?temp_user_id=" + localStorage.temp_user_id
    list.fetch
      success: ->
        if list.get("list")
          window.list_type = "List"
          @show_view = new MoviesApp.ListsShow(list: list)
          $(".list-show-main-items").html @show_view.render().el
          if list.get("list").list_type == "gallery"
            window.list_type = "gallery"
            @edit_images_view = new MoviesApp.EditImagesGallery(images: [])
            $(".add-images-form").append @edit_images_view.render().el
            $(".slimbox").slimbox({ maxHeight: 700, maxWidth: 1000 })

  remove_keyword: (e) ->
    parent = $(e.target).parents(".keyword").first()
    id = parent.attr("data-id")
    $.ajax api_version + "list_keywords/test",
      method: "DELETE"
      data:
        listable_id: window.list_id
        listable_type: window.list_type
        keyword_id: id
      success: ->
        parent.remove()
        $(".notifications").html("Keyword successfully removed.").show().fadeOut(window.hide_delay)

  remove_tag: (e) ->
    parent = $(e.target).parents(".tag").first()
    id = parent.attr("data-id")
    type = parent.attr("data-type")
    $.ajax api_version + "list_tags/test",
      method: "DELETE"
      data:
        listable_id: window.list_id
        listable_type: window.list_type
        taggable_id: id
        taggable_type: type
      success: ->
        parent.remove()
        $(".notifications").html("Tag successfully removed.").show().fadeOut(window.hide_delay)

  approve_keyword: (e) ->
    parent = $(e.target).parents(".keyword").first()
    id = parent.attr("data-id")
    list_keyword = new MoviesApp.ListKeyword()
    list_keyword.save ({ id: "0", list_keyword: {  listable_id: window.list_id, listable_type: window.list_type, keyword_id: id, approved: true } }),
      success: ->
        parent.find(".js-approve-keyword").remove()
        $(".notifications").html("Keyword successfully approved.").show().fadeOut(window.hide_delay)

  approve_tag: (e) ->
    parent = $(e.target).parents(".tag").first()
    id = parent.attr("data-id")
    type = parent.attr("data-type")
    list_tag = new MoviesApp.ListTag()
    list_tag.save ({ id: "0", list_tag: { listable_id: window.list_id, listable_type: window.list_type, taggable_id: id, taggable_type: type, keyword_id: id, approved: true } }),
      success: ->
        parent.find(".js-approve-tag").remove()
        $(".notifications").html("Tag successfully approved.").show().fadeOut(window.hide_delay)

  approve_list: (e) ->
    self = @
    container = $(e.target)
    id = container.attr("data-id")
    type = container.attr("data-model")
    $.ajax api_version + "approvals/mark",
      method: "post"
      data:
        approved_id: id
        original_id: id
        type: type
        mark: true
      success: ->
        $(".js-approve-list").hide().addClass("hide")
        $(".js-unapprove-list").show().removeClass("hide")

  unapprove_list: (e) ->
    self = @
    container = $(e.target)
    id = container.attr("data-id")
    type = container.attr("data-model")
    $.ajax api_version + "approvals/mark",
      method: "post"
      data:
        approved_id: id
        original_id: id
        type: type
        mark: false
      success: ->
        $(".js-approve-list").show().removeClass("hide")
        $(".js-unapprove-list").hide().addClass("hide")


