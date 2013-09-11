class SocialApp < ActiveRecord::Base
  attr_accessible :link, :social_app, :approved
  has_many :person_social_apps, :dependent => :destroy

  validates_presence_of :social_app, :link
  validates :social_app, :uniqueness => { :case_sensitive => false }
  validates :link, :uniqueness => { :case_sensitive => false }

end
