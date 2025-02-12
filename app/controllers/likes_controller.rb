class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @thought = Thought.find(params[:thought_id])
    unless @thought.likes.exists?(user: current_user)
      @thought.likes.create(user: current_user)
    end
    respond_to do |format|
      format.html { redirect_to thoughts_path }
      format.js
    end
  end

  def destroy
    @thought = Thought.find(params[:thought_id])
    like = @thought.likes.find_by(user: current_user)
    like.destroy if like
    respond_to do |format|
      format.html { redirect_to thoughts_path }
      format.js
    end
  end
end
