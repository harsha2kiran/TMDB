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
  has_many :badges, :through => :user_badges

  after_create :activate
  before_create :set_user_type

  def active_for_authentication?
    super && self.active == true
  end

  def inactive_message
    "Sorry, this account has been deactivated."
  end

  protected

  def activate
    self.active = true
    self.save
  end

  def set_user_type
    self.user_type = "user"
  end

end
