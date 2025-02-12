# class User < ApplicationRecord
#   devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

#   has_many :thoughts, dependent: :destroy
#   has_many :likes, dependent: :destroy

#   # Friendships
#   has_many :friendships, dependent: :destroy
#   has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id", dependent: :destroy

#   # Pending friend requests
#   has_many :pending_sent_requests, -> { where(status: 'pending') }, class_name: "Friendship", foreign_key: "user_id"
#   has_many :pending_received_requests, -> { where(status: 'pending') }, class_name: "Friendship", foreign_key: "friend_id"

#   # Accepted friendships
#   has_many :accepted_friendships, -> { where(status: 'accepted') }, class_name: "Friendship", foreign_key: "user_id"
#   has_many :inverse_accepted_friendships, -> { where(status: 'accepted') }, class_name: "Friendship", foreign_key: "friend_id"

#   # All friends (both ways)
#   def friends
#     User.where(id: accepted_friendships.pluck(:friend_id) + inverse_accepted_friendships.pluck(:user_id))
#   end

#   # Users who sent friend requests to the current user
#   def pending_requests
#     User.where(id: pending_received_requests.pluck(:user_id))
#   end

#   # Users the current user sent friend requests to
#   def inverse_pending_requests
#     User.where(id: pending_sent_requests.pluck(:friend_id))
#   end

#   # Suggested users (users who are not friends and have no pending requests)
#   def suggested_users
#     User.where.not(id: (friends + pending_requests + inverse_pending_requests + [self]).map(&:id)).limit(5)
#   end
# end



class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :thoughts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"

  # Friends that the user has sent requests to (pending requests)
  has_many :pending_sent_requests, -> { where(status: 'pending') }, class_name: "Friendship"
  has_many :pending_received_requests, -> { where(status: 'pending') }, class_name: "Friendship", foreign_key: "friend_id"

  # Accepted friendships
  has_many :accepted_friendships, -> { where(status: 'accepted') }, class_name: "Friendship"
  has_many :friends, through: :accepted_friendships, source: :friend

  # Users who sent friend requests to the current user
  def pending_requests
    pending_received_requests.map(&:user)
  end

  # Users who are accepted friends
  def accepted_friends
    friends
  end
  def suggested_users
  User.where.not(id: (friends + pending_requests + inverse_pending_requests + [self]).map(&:id)).limit(5)
end

def inverse_pending_requests
  pending_sent_requests.map(&:friend)
end


  # Suggested friends (users who are not friends or pending requests)
  def suggested_users
    User.where.not(id: (friends + pending_requests + [self]).map(&:id)).limit(5)
  end
end