class Crew < ActiveRecord::Base
  attr_accessible :approved, :job, :movie_id, :person_id
end
