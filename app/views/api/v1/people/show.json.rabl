object @person
attributes :id, :original_id, :user_id, :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth, :created_at, :updated_at
if @all

  node(:alternative_names) { |person| partial("api/v1/alternative_names/index", :object => person.alternative_names) }
  node(:crews) { |person| partial("api/v1/crews/index", :object => person.crews) }
  node(:casts) { |person| partial("api/v1/casts/index", :object => person.casts) }
  node(:person_social_apps) { |person| partial("api/v1/person_social_apps/index", :object => person.person_social_apps) }
  node(:tags) { |person| partial("api/v1/tags/index", :object => person.tags ) }
  node(:images) { |person| person.images }
  node(:videos) { |movie| movie.videos }

else

  node(:alternative_names) { |person| partial("api/v1/alternative_names/index", :object => person.alternative_names.select {|s| s.approved == true }) }
  node(:crews) { |person| partial("api/v1/crews/index", :object => person.crews.select {|s| s.approved == true }) }
  node(:casts) { |person| partial("api/v1/casts/index", :object => person.casts.select {|s| s.approved == true }) }
  node(:person_social_apps) { |person| partial("api/v1/person_social_apps/index", :object => person.person_social_apps.select {|s| s.approved == true }) }
  node(:tags) { |person| partial("api/v1/tags/index", :object => person.tags.select {|s| s.approved == true }) }
  node(:images) { |person| person.images.select {|s| s.approved == true } }
  node(:videos) { |person| person.videos.select {|s| s.approved == true } }

end

node(:follows) { |person| person.follows }
node(:views) { |person| person.views.count }
