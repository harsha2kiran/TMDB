class SocialApp < ActiveRecord::Base
  attr_accessible :link, :social_app
  has_many :person_social_apps

  validates_presence_of :social_app, :link

end
