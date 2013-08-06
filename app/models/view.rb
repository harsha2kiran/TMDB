class View < ActiveRecord::Base
  attr_accessible :viewable_id, :viewable_type, :views_count
  belongs_to :viewable, polymorphic: true
end
