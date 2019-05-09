class UsersController < ApplicationController
  # before_action :authenticate_user!
  before_action :set_users, only: [:show]

  def show
    # redirect_to root_path, alert: "Denied permission" unless current_user == @user
    # @rooms = current_user.rooms
    @rooms = @user.rooms

    # I take above user's id searching in host_id column of Review table
    # display all the 'guest' reviews to host (if this user is a host)
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    # Display all the 'host' reviews (about) guest (if this user is a guest)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
  end

  private

  def set_users
    @user = User.find(params[:id])
  end
end

# 1. to see user needs to be login
# 2. User can see just his own profile -> changed
