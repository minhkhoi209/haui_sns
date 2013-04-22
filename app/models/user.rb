class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable,
  :token_authenticatable, :authentication_keys => [:login]

  before_save :ensure_authentication_token
  attr_accessor :login
  validates_uniqueness_of :username
  validates_presence_of :username
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :login, :username, :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  has_many :friendships
  has_many :friends, :through => :friendships
  # has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  # has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  # Essential functions

  def friend_of?(other_user)
    Friendship.exists?(:user_id => self, :friend_id=>other_user)
  end


  def self.find_first_by_auth_conditions(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      else
        where(conditions).first
      end
    end
end
