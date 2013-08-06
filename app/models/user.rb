class User < ActiveRecord::Base
  attr_accessible :biography, :confirmed_at, :email, :first_name, :image_file, :last_name, :password, :points, :user_type
  has_many :user_badges
  has_many :badges, :through => :user_badges
end
