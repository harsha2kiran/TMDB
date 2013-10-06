class MediaKeyword < ActiveRecord::Base
  attr_accessible :keyword_id, :mediable_id, :mediable_type, :temp_user_id, :user_id, :approved
  belongs_to :keyword
  belongs_to :mediable, polymorphic: true
end
