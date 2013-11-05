class MoviesApp.SingleVideoTags extends Backbone.View
  template: JST['templates/tags/edit_single_video_tags']
  className: "row edit-single-video-tags"

  events:
    "click .js-remove-tag" : "remove_tag"
    "click .js-approve-tag" : "approve_tag"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    @container = $(@el)
    if @options.item
      item = @options.item
      @container.html @template(item: item)
    else
      @container.html @template
    @init_tags_autocomplete()
    this

  init_tags_autocomplete: ->
    self = @
    $(@el).find(".js-new-tag").autocomplete
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
            $(self.el).find(".js-tags-movies-list .tag-tag").each ->
              if $.trim($(@).html()) == ui.item.label
                found = true
          else if ui.item.type == "Person"
            tags_list_el = ".js-tags-people-list"
            $(self.el).find(".js-tags-people-list .tag-tag").each ->
              if $.trim($(@).html()) == ui.item.label
                found = true
          else if ui.item.type == "Company"
            tags_list_el = ".js-tags-companies-list"
            $(self.el).find(".js-tags-companies-list .tag-tag").each ->
              if $.trim($(@).html()) == ui.item.label
                found = true
          if found
            $(".notifications").html("Tag already added.").show().fadeOut(window.hide_delay)
            $(@).val("")
          else
            tags_list = self.container.find(tags_list_el).find(".tag")
            tag_ids.push ui.item.id
            tags.push [ui.item.id, ui.item.type, ui.item.label]
            @tags_view = new MoviesApp.Tags(tags: tags)
            self.container.find(tags_list_el).append @tags_view.render().el
        $(@).val("")
        return false
      response: (event, ui) ->
        ui.content = window.check_tags_autocomplete(ui.content, $.trim($(".js-new-tag").val()))
        if ui.content.length == 0
          self.container.find(".js-new-item-info, .js-new-item-add-form").show()
          self.container.find(".js-new-tag-id").val("")
        else
          self.container.find(".js-new-item-info, .js-new-item-add-form").hide()

  add_new_tag: (type) ->
    self = @
    value = @container.find(".js-new-tag").val()
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
          $(self.el).find(".js-new-tag").val("").removeClass "error"
          $(self.el).find(".js-new-tag-id").val("")
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
          self.container.find(tags_list_el).append @tags_view.render().el

        error: (model, response) ->
          $(".notifications").html("Tag is currently waiting for moderation.").show().fadeOut(window.hide_delay)
          $(self.el).find(".js-new-tag").val("").removeClass "error"
          $(self.el).find(".js-new-tag-id").val("")
    else
      @container.find(".js-new-tag").addClass("error")

  remove_tag: (e) ->
    parent = $(e.target).parents(".tag").first()
    id = parent.attr("data-id")
    type = parent.attr("data-type")
    $.ajax api_version + "media_tags/test?temp_user_id=" + localStorage.temp_user_id,
      method: "DELETE"
      data:
        mediable_id: window.video_id
        mediable_type: "Video"
        taggable_id: id
        taggable_type: type
      success: ->
        parent.remove()
        $(".notifications").html("Tag successfully removed.").show().fadeOut(window.hide_delay)

  approve_tag: (e) ->
    parent = $(e.target).parents(".tag").first()
    id = parent.attr("data-id")
    type = parent.attr("data-type")
    list_tag = new MoviesApp.MediaTag()
    list_tag.save ({ id: "0", media_tag: { mediable_id: window.video_id, mediable_type: "Video", taggable_id: id, taggable_type: type, approved: true } }),
      success: ->
        parent.find(".js-approve-tag").remove()
        $(".notifications").html("Tag successfully approved.").show().fadeOut(window.hide_delay)

