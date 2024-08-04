class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc) # Ensure posts are ordered from recent to oldest
    @subscriptions = @user.subscriptions.includes(:trader)
    Rails.logger.debug "Fetched posts: #{@posts.inspect}"
  end

  def feed
    @posts = current_user.feed
    Rails.logger.debug "Fetched feed posts: #{@posts.inspect}"
  end
  
  private

  def set_user
    @user = User.find(params[:id])
  end
end
