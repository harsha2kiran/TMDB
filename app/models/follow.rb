class Follow < ActiveRecord::Base
  attr_accessible :approved, :followable_id, :followable_type, :user_id
  belongs_to :followable, polymorphic: true
end
