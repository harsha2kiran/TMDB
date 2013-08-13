object @people
attributes :id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at, :user_id
if @all

  node(:alternative_names) { |person| partial("api/v1/alternative_names/index", :object => person.alternative_names) }
  node(:crews) { |person| partial("api/v1/crews/index", :object => person.crews) }
  node(:casts) { |person| partial("api/v1/casts/index", :object => person.casts) }
  node(:person_social_apps) { |person| partial("api/v1/person_social_apps/index", :object => person.person_social_apps) }
  node(:tags) { |person| partial("api/v1/tags/index", :object => person.tags ) }
  node(:images) { |person| person.images }
  node(:follows) { |person| person.follows }
  node(:views) { |person| person.views }
else

  node(:alternative_names) { |person| partial("api/v1/alternative_names/index", :object => person.alternative_names.where(approved: true)) }
  node(:crews) { |person| partial("api/v1/crews/index", :object => person.crews.where(approved: true)) }
  node(:casts) { |person| partial("api/v1/casts/index", :object => person.casts.where(approved: true)) }
  node(:person_social_apps) { |person| partial("api/v1/person_social_apps/index", :object => person.person_social_apps.where(approved: true)) }
  node(:tags) { |person| partial("api/v1/tags/index", :object => person.tags.where(approved: true) ) }
  node(:images) { |person| person.images.where(approved: true) }
  node(:follows) { |person| person.follows }
  node(:views) { |person| person.views }
end
