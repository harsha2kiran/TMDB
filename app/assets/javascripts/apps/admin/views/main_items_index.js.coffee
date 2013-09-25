class AdminApp.MainItemsIndex extends Backbone.View
  template: JST['templates/admin/main_items_index']
  className: "row-fluid main-items-index"

  initialize: ->
    _.bindAll this, "render"

  render: ->
    self = @
    index = $(@el)
    items = @options.items
    type = @options.type
    index.html @template(items: items, type: type)


    oTable = $(@el).find(".datatable").dataTable
      bJQueryUI: true
      sDom: "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>"
      sPaginationType: "bootstrap"

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

