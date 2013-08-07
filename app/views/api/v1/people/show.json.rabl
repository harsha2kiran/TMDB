object @person
attributes :id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at
node(:alternative_names) { @person.alternative_names }
node(:crews) { @person.crews }
node(:casts) { @person.casts }
node(:person_social_apps) { @person.person_social_apps }
node(:tags) { @person.tags }
node(:images) { @person.images }
node(:follows) { @person.follows }
node(:views) { @person.views }
