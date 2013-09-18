class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password_confirmation, :remember_me
  attr_accessible :biography, :confirmed_at, :email, :first_name, :image_file, :last_name, :password, :points, :user_type
  has_many :user_badges
  has_many :lists
  has_many :follows
  has_many :images
  has_many :movies
  has_many :videos
  has_many :people
  has_many :casts
  has_many :crews
  has_many :movie_genres
  has_many :movie_keywords
  has_many :movie_languages
  has_many :movie_metadatas
  has_many :production_companies
  has_many :releases
  has_many :tags
  has_many :alternative_names
  has_many :person_social_apps
  has_many :alternative_titles
  has_many :badges, :through => :user_badges

  after_create :activate
  before_create :set_user_type

  def active_for_authentication?
    super && self.active == true
  end

  # def inactive_message
  #   "Account is not yet confirmed. Please click on validation link sent on mail."
  # end

  protected

  def activate
    self.active = true
    self.save
  end

  def set_user_type
    self.user_type = "user"
  end

end
