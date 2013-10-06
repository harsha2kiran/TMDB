class MediaTag < ActiveRecord::Base
  attr_accessible :mediable_id, :mediable_type, :taggable_id, :taggable_type, :temp_user_id, :user_id

  belongs_to :mediable, polymorphic: true
  belongs_to :taggable, polymorphic: true
end
