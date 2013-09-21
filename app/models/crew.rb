class Crew < ActiveRecord::Base
  attr_accessible :approved, :job, :movie_id, :person_id, :user_id, :temp_user_id
  belongs_to :movie
  belongs_to :user
  belongs_to :person

  validates_presence_of :job, :movie_id, :person_id
  validates :job, :uniqueness => { :scope => [:person_id, :movie_id], :case_sensitive => false }

end
