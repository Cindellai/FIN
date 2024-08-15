class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update]
  before_action :hide_footer, only: [:feed]


  def show
    @posts = @user.posts.order(created_at: :desc)
  end

  def edit
  end

  def feed
    @user = current_user
    @posts = @user.feed_posts

    # Determine trending topics based on the most common topics in posts
    topics = ['Algorithmic Trading', 'Market Analysis', 'AI in Finance', 'Cryptocurrency', 'Python for Trading', 'Investment Strategies']
    @trending_topics = topics.map do |topic|
      count = Post.where('title LIKE ? OR body LIKE ?', "%#{topic}%", "%#{topic}%").count
      { text: topic, count: count }
    end

    # Who to know logic
    @who_to_know = User.where.not(id: @user.id).limit(5)
  end


  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile was successfully updated.'
    else
      render :edit
    end
  end

  private

  def hide_footer
    @hide_footer = true
  end

  def set_user
  @user = User.find_by(id: params[:id])
  unless @user
    flash[:alert] = "User not found."
    redirect_to root_path # Redirect to a safe path, e.g., home page
  end
end


  def user_params
    params.require(:user).permit(:username, :bio, :profile_picture)
  end
end
