class AdminApp.MainItemsIndex extends Backbone.View
  template: JST['templates/admin/main_items_index']
  className: "main-items-index"

  initialize: ->
    _.bindAll this, "render"

  events:
    "click .js-remove" : "remove"
    # "click .js-approve" : "approve"
    "click .js-unapprove" : "unapprove"

  render: ->
    self = @
    index = $(@el)
    items = @options.items
    type = @options.type
    index.html @template(items: items, type: type)

    oTable = $(@el).find(".datatable").dataTable
      bJQueryUI: true
      sDom: "<'dataTableTopMenu'<'col-md-6'l><'span6'f>r>t<''<'span6'i><'span6'p>>"
      sPaginationType: "bootstrap"
      bJQueryUI: true
      bProcessing: true
      bServerSide: true
      sAjaxSource: api_version + "approvals/main_items?type=" + type
      fnCreatedRow: ( nRow, aData, iDataIndex ) ->
        $('td:eq(0)', nRow).attr("data-id", "title").addClass("jeditable").html(aData[1])
        $('td:eq(1)', nRow).attr("data-id", "overview").addClass("jeditable").html(aData[2])
        $('td:eq(2)', nRow).attr("data-id", "tagline").addClass("jeditable").html(aData[3])
        $('td:eq(3)', nRow).attr("data-id", "content_score").addClass("jeditable").html(aData[4])

        $('td:eq(4)', nRow).html "<a class='col-md-6 btn btn-primary flat' href='#admin/movies/" + aData[0] + "'>Moderate</a>"
        if aData[6] || aData[7] == false
          $('td:eq(4)', nRow).append "(Pending)"
        else
          $('td:eq(4)', nRow).append "<button class='js-unapprove btn' data-id='" + aData[0] + "' data-controller='movies'>Unapprove</button>"
        $('td:eq(5)', nRow).html "<button class='js-remove btn' data-id='" + aData[0] + "' data-controller='movies'>Delete</button>"
      fnRowCallback: (nRow, aData, iDisplayIndex) ->
        $(nRow).attr("data-id", aData[0])
        $(nRow).attr("data-model", "Movie")
        return nRow
      fnDrawCallback: ->
        oTable.$("td.jeditable").editable api_version + "approvals/inline_edit",
          callback: (sValue, y) ->
            aPos = oTable.fnGetPosition(this)
            oTable.fnUpdate sValue, aPos[0], aPos[1]
          submitdata: (value, settings) ->
            id: @parentNode.getAttribute("data-id")
            model: @parentNode.getAttribute("data-model")
            column: this.getAttribute("data-id")
          height: "14px"
          width: "100%"
    this

  remove: (e) ->
    self = @
    container = $(e.target).parents("tr").first()
    id = $(e.target).attr("data-id")
    controller = $(e.target).attr("data-controller")
    if confirm("Remove item?") == true
      $.ajax api_version + controller + "/" + id,
        method: "DELETE"
        success: =>
          $(".notifications").html("Successfully removed item.").show().fadeOut(window.hide_delay)
          container.remove()
          if controller == "movies"
            type = "Movie"
          else
            type = "Person"
          self.reload_datatable(type)

  # approve: (e) ->
  #   self = @
  #   container = $(e.target).parents("tr").first()
  #   id = container.attr("data-id")
  #   type = container.attr("data-model")
  #   $.ajax api_version + "approvals/mark",
  #     method: "post"
  #     data:
  #       approved_id: id
  #       original_id: id
  #       type: type
  #       mark: true
  #     success: ->
  #       self.reload_datatable(type)

  unapprove: (e) ->
    self = @
    container = $(e.target).parents("tr").first()
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
        self.reload_datatable(type)

  reload_datatable: (type) ->
    items = new AdminApp.MainItems()
    if window.list_type == "gallery"
      items.url = api_version + "lists/galleries"
      type = "Gallery"
    else if window.list_type == "channel"
      items.url = api_version + "lists/channels"
      type = "Channel"
    else
      items.url = api_version + "approvals/main_items"
    items.fetch
      data:
        type: type
      success: ->
        @index_view = new AdminApp.MainItemsIndex(items: items, type: type)
        $(".js-content").html @index_view.render().el
