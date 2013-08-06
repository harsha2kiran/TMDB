class Image < ActiveRecord::Base
  attr_accessible :approved, :image_file, :image_type, :is_main_image, :item_id, :item_type, :title
end
