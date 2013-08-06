class People < ActiveRecord::Base
  attr_accessible :approved, :biography, :birthday, :day_of_death, :homepage, :imdb_id, :locked, :name, :place_of_birth
end
