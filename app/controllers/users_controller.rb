class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users, only: [:show]

  def show
    redirect_to root_path, alert: "Denied permission" unless current_user == @user
  end

  private

  def set_users
    @user = User.find(params[:id])
  end
end

# 1. to see user needs to be login
# 2. User can see just his own profile
