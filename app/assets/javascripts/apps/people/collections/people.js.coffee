class PeopleApp.People extends Backbone.Collection
  model: PeopleApp.Person
  url: "/api/v1/people"
