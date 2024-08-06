class UsersController < ApplicationController
  # before_action :authenticate_user!, only: [:show] # Comment out this line to disable authentication
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

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  def feed
    @posts = Post.order(created_at: :desc).includes(:user, :trade)
    Rails.logger.debug "Fetched feed posts: #{@posts.inspect}"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :bio, :profile_picture, :banner_image)
  end
end
