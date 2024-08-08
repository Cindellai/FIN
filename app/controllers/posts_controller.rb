class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:edit, :update, :show, :destroy]

  def index
    @posts = Post.all.order(created_at: :desc)
  end

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
      flash.now[:alert] = @post.errors.full_messages.join(', ')
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
      flash.now[:alert] = @post.errors.full_messages.join(', ')
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
    params.require(:post).permit(:title, :body, :post_type, :file, trade_attributes: [:id, :stock_name, :executed_at, :performance, :buy_or_sell, :quantity, :price, :description, :_destroy, :poster_id])
  end
end
