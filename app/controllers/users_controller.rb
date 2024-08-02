class UsersController < ApplicationController
  # Skip authentication for testing purposes
  #before_action :authenticate_user!, only: [:show]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    if @user.trader?
      @posts = @user.posts
      @trades = @user.trades
    end
    @subscriptions = @user.subscriptions if current_user&.student?
  end
end
