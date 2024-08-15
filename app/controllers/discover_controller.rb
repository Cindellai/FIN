class DiscoverController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all # Fetch all users
  end
end
