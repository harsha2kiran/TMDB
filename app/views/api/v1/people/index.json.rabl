object @people
attributes :id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at
node(:alternative_names) { |person| person.alternative_names }
node(:crews) { |person| person.crews }
node(:casts) { |person| person.casts }
node(:person_social_apps) { |person| person.person_social_apps }
node(:tags) { |person| person.tags }
node(:images) { |person| person.images }
node(:follows) { |person| person.follows }
node(:views) { |person| person.views }
