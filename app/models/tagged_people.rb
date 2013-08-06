class TaggedPeople < ActiveRecord::Base
  attr_accessible :approved, :taggable_id, :taggable_type
  belongs_to :taggable, polymorphic: true
end
