class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def new
    @post = @user.posts.build
  end

  def create
    @post = @user.posts.build(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @user, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @user, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to @user, notice: 'Post was successfully destroyed.'
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = @user.posts.find(params[:id])
  end

  def authorize_user!
    redirect_to @user, alert: 'You are not authorized to perform this action.' unless @post.user == current_user
  end

  def post_params
    params.require(:post).permit(:title, :body, :post_type, :file, trade_attributes: [:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :poster_id])
  end
end
