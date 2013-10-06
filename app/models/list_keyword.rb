class ListKeyword < ActiveRecord::Base
  attr_accessible :keyword_id, :listable_id, :listable_type, :temp_user_id, :user_id
  belongs_to :keyword
  # belongs_to :listable, polymorphic: true
end
