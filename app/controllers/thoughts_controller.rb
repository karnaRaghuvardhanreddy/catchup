class ThoughtsController < ApplicationController
  before_action :authenticate_user!

   def index
    # Include the current user's posts and friends' posts
    friend_ids = current_user.accepted_friends.pluck(:id)
    @thoughts = Thought.where(user_id: [current_user.id] + friend_ids).order(created_at: :desc)
  end
  def new
    @thought = Thought.new  
  end

  def create
    current_user.thoughts.create(thought_params)
    redirect_to thoughts_path
  end

  def destroy
    thought = current_user.thoughts.find(params[:id])
    thought.destroy
    redirect_to thoughts_path
  end

  private

  def thought_params
    params.require(:thought).permit(:content)
  end
end
