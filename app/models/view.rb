class View < ActiveRecord::Base
  attr_accessible :item_id, :item_type, :views_count
end
