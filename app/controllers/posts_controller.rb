class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:edit, :update, :show, :destroy] # Ensure only defined actions are listed here

  def new
    @post = Post.new
    @form_submit_text = "Create Post"
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      @form_submit_text = "Create Post"
      render :new
    end
  end

  def edit
    @form_submit_text = "Update Post"
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      @form_submit_text = "Update Post"
      render :edit
    end
  end

  def show
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
    params.require(:post).permit(:title, :body, :post_type, :url, trade_attributes: [:stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description])
  end
end
