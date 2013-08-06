class SocialApp < ActiveRecord::Base
  attr_accessible :link, :social_app
  has_many :person_social_apps
end
