class AdminApp.Items extends Backbone.Collection
  model: AdminApp.Item
  url: "/api/v1/approvals/items"
