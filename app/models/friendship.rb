class Friendship < ActiveRecord::Base
  attr_accessible :friend_from, :friend_id, :user_id
  belongs_to :user
  belongs_to :friend, :class_name => 'User'

  def self.is_friend?(friendship)
  	Friendship.exists?(:user_id => friendship.user_id, :friend_id => friendship.friend_id)
  end
end
