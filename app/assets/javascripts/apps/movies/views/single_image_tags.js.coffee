class MoviesApp.SingleImageTags extends Backbone.View
  template: JST['templates/tags/edit_single_image_tags']
  className: "row-fluid edit-single-image-tags"

  events:
    "click .js-remove-tag" : "remove_tag"
    "click .js-approve-tag" : "approve_tag"

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
    $(@el).find(".js-new-tag").autocomplete
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
          tags_list = self.container.find(tags_list_el).find(".tag")
          tags_list.each ->
            tags.push [$(@).attr("data-id"), $(@).attr("data-type"), $.trim($(@).find(".tag-tag").html())]
            tag_ids.push parseInt($(@).attr("data-id"))
          if $.inArray(parseInt(ui.item.id), tag_ids) == -1
            tag_ids.push ui.item.id
            tags.push [ui.item.id, ui.item.type, ui.item.label]
          @tags_view = new MoviesApp.Tags(tags: tags)
          self.container.find(tags_list_el).html @tags_view.render().el
        $(".ui-autocomplete-input").val("")
      # response: (event, ui) ->
      #   ui.content = window.check_autocomplete(ui.content, $.trim($(".js-new-tag-person").val()), "person")
      #   if ui.content.length == 0
      #     $(self.el).find(".js-new-person-info, .js-new-person-add-form").show()
      #     $(self.el).find(".js-new-person-id").val("")
      #   else
      #     self.edit.find(".js-new-person-info, .js-new-person-add-form").hide()

  add_new_item: (e) ->
    console.log ""

  remove_tag: (e) ->
    parent = $(e.target).parents(".tag").first()
    id = parent.attr("data-id")
    type = parent.attr("data-type")
    $.ajax api_version + "media_tags/test",
      method: "DELETE"
      data:
        mediable_id: window.image_id
        mediable_type: "Image"
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
    list_tag.save ({ id: "0", media_tag: { mediable_id: window.image_id, mediable_type: "Image", taggable_id: id, taggable_type: type, approved: true } }),
      success: ->
        parent.find(".js-approve-tag").remove()
        $(".notifications").html("Tag successfully approved.").show().fadeOut(window.hide_delay)

