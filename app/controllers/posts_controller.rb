class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
    @post.build_trade if @post.post_type == 'trade_idea'
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      if @post.post_type == 'trade_idea'
        trade_params = params.require(:post).permit(trade_attributes: [:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description])
        @post.create_trade(trade_params[:trade_attributes].merge(poster_id: current_user.id))
      end
      redirect_to user_profile_path(current_user), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
    @post.build_trade if @post.post_type == 'trade_idea' && @post.trade.nil?
  end

  def update
    if @post.update(post_params)
      if @post.post_type == 'trade_idea'
        trade_params = params.require(:post).permit(trade_attributes: [:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description])
        if @post.trade
          @post.trade.update(trade_params[:trade_attributes])
        else
          @post.create_trade(trade_params[:trade_attributes].merge(poster_id: current_user.id))
        end
      end
      redirect_to user_profile_path(current_user), notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to user_profile_path(current_user), notice: 'Post was successfully deleted.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :post_type, :url, :body, :posted_by, trade_attributes: [:id, :stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description])
  end
end

