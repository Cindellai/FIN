class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
    if @post.post_type == 'trade_idea'
      @trade = @post.trade || @post.build_trade
    end
  end

  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      if @post.post_type == 'trade_idea'
        trade_params = params.require(:trade).permit(:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description)
        trade = @post.build_trade(trade_params.merge(user_id: current_user.id))
        unless trade.save
          @post.destroy
          render :new, status: :unprocessable_entity
          return
        end
      end
      redirect_to user_profile_path(current_user), notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    Rails.logger.debug "Updating post: #{@post.inspect}"
    Rails.logger.debug "Post params: #{post_params.inspect}"
    if @post.update(post_params)
      if @post.post_type == 'trade_idea'
        trade_params = params.require(:trade).permit(:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description)
        if @post.trade
          @post.trade.update(trade_params)
        else
          @post.create_trade(trade_params.merge(user_id: current_user.id))
        end
      end
      redirect_to user_profile_path(current_user), notice: 'Post was successfully updated.'
    else
      Rails.logger.debug "Update failed: #{@post.errors.full_messages}"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :url, :post_type, trade_attributes: [:id, :stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description])
  end
end
