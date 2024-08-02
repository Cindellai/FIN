class UsersController < ApplicationController
  #before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    if @user.trader?
      @posts = @user.posts
      @trades = @user.trades
    end
    @subscriptions = @user.subscriptions if current_user.student?
  end
end
