class ListItem < ActiveRecord::Base
  attr_accessible :approved, :list_id, :listable_id, :listable_type
  belongs_to :listable, polymorphic: true
end
