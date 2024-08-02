class UsersController < ApplicationController
  # Skip authentication for testing purposes
  #before_action :authenticate_user!, only: [:show]
  before_action :set_user, only: [:show]

  def index
    @users = User.all
  end

  def show
    @posts = @user.posts || []
    @subscriptions = current_user&.subscriptions || []
    @subscribers = @user.subscribers if @user.trader?
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
