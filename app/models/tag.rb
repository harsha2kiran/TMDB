class Tag < ActiveRecord::Base
  attr_accessible :approved, :person_id, :taggable_id, :taggable_type
  belongs_to :people
end
