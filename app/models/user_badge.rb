class UserBadge < ActiveRecord::Base
  attr_accessible :badge_id, :user_id
  belongs_to :user
  belongs_to :badge

  validates_presence_of :badge_id, :user_id

end
