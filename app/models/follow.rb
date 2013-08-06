class Follow < ActiveRecord::Base
  attr_accessible :approved, :item_id, :item_type, :user_id
end
