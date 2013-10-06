class ListTag < ActiveRecord::Base
  attr_accessible :listable_id, :listable_type, :taggable_id, :taggable_type, :temp_user_id, :user_id

  # belongs_to :listable, polymorphic: true
  belongs_to :taggable, polymorphic: true
end
