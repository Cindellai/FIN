class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to user_profile_path(current_user), notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @post.destroy
    redirect_to user_profile_path(current_user), notice: 'Post was successfully deleted.'
  end

  def update
    if @post.update(post_params)
      redirect_to user_profile_path(current_user), notice: 'Post was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_post
    logger.debug "Fetching post with ID: #{params[:id]}"
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :url)
  end
end
