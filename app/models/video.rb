class Video < ActiveRecord::Base
  attr_accessible :approved, :item_id, :item_type, :link, :link_active, :priority, :quality, :video_type
end
