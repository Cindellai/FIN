class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def show
    # @post is already set by the before_action :set_post
  end

  def edit
    # @post is already set by the before_action :set_post
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @post.user == current_user
      @post.destroy
      redirect_to user_path(current_user), notice: 'Post was successfully deleted.'
    else
      redirect_to user_path(current_user), alert: 'You are not authorized to delete this post.'
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :url)
  end
end
