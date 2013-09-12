class Cast < ActiveRecord::Base
  attr_accessible :approved, :character, :movie_id, :person_id, :user_id, :temp_user_id
  belongs_to :movie
  belongs_to :person
  belongs_to :user

  validates_presence_of :character, :movie_id, :person_id
  validates :character, :uniqueness => { :scope => [:person_id, :movie_id] }

end
