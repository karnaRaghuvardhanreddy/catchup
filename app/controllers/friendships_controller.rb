# class FriendshipsController < ApplicationController
#   before_action :authenticate_user!

#   def index
#     @pending_requests = current_user.pending_received_requests

#     if params[:query].present?
#       @suggested_users = User.where("email LIKE ?", "%#{params[:query]}%")
#     else
#       excluded_users = current_user.friends + current_user.pending_requests + current_user.inverse_pending_requests + [current_user]
#       @suggested_users = User.where.not(id: excluded_users.map(&:id))
#     end
#   end

#   def create
#   friend = User.find(params[:user_id])
  
#   # Prevent duplicate friendships
#   unless Friendship.exists?(user_id: current_user.id, friend_id: friend.id) || 
#          Friendship.exists?(user_id: friend.id, friend_id: current_user.id)
    
#     @friendship = current_user.friendships.create(friend: friend, status: "pending")

#     if @friendship.persisted?
#       render json: { status: "success", message: "Friend request sent", friend_id: friend.id }
#     else
#       render json: { status: "error", message: @friendship.errors.full_messages.join(", ") }, status: :unprocessable_entity
#     end
#   else
#     render json: { status: "error", message: "Friend request already sent" }, status: :unprocessable_entity
#   end
# end

#   def update
#   friendship = Friendship.find(params[:id])

#   if friendship.friend == current_user && friendship.status == "pending"
#     friendship.update!(status: "accepted")
#     Friendship.create!(user: friendship.friend, friend: friendship.user, status: "accepted")

#     render json: { status: "success", message: "Friend request accepted", friend_id: friendship.user.id }
#   else
#     render json: { status: "error", message: "Unable to accept request" }, status: :unprocessable_entity
#   end
# end
# def destroy
#   friendship = Friendship.find(params[:id])

#   if friendship.friend == current_user || friendship.user == current_user
#     friendship.destroy
#     render json: { status: "success", message: "Friend request rejected", friendship_id: friendship.id }
#   else
#     render json: { status: "error", message: "Not authorized to delete this request" }, status: :forbidden
#   end
# end


# end


class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pending_requests = current_user.pending_received_requests

    if params[:query].present?
      @suggested_users = User.where("email LIKE ?", "%#{params[:query]}%")
    else
      excluded_users = current_user.friends + current_user.pending_requests + current_user.inverse_pending_requests + [current_user]
      @suggested_users = User.where.not(id: excluded_users.map(&:id))
    end
  end

  def create
    friend = User.find(params[:user_id])

    # Prevent duplicate friendships, handle race conditions
    @friendship = Friendship.find_or_initialize_by(user_id: current_user.id, friend_id: friend.id)

    if @friendship.new_record?
      @friendship.status = "pending" # Set status only for new records
    end

    if @friendship.save
      render json: { status: "success", message: "Friend request sent", friend_id: friend.id }
    else
      render json: { status: "error", message: @friendship.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end


  def update
    friendship = Friendship.find(params[:id])

    if friendship.friend == current_user && friendship.status == "pending"
      Friendship.transaction do
        friendship.update!(status: "accepted")
        Friendship.find_or_create_by(user: friendship.friend, friend: friendship.user) { |f| f.status = "accepted" }
      end

      render json: { status: "success", message: "Friend request accepted", friend_id: friendship.user.id }
    else
      render json: { status: "error", message: "Unable to accept request" }, status: :unprocessable_entity
    end
  end

  def destroy
    friendship = Friendship.find(params[:id])

    if friendship.friend == current_user || friendship.user == current_user
      friendship.destroy
      render json: { status: "success", message: "Friend request rejected", friendship_id: friendship.id }
    else
      render json: { status: "error", message: "Not authorized to delete this request" }, status: :forbidden
    end
  end
end