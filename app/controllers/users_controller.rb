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

  # TWILIO - sms
  def update_phone_number
    # added new or updated phone num in user profile
    current_user.update_attributes(user_params)
    # method from user model
    current_user.generate_pin
    # send pin to user
    current_user.send_pin

    redirect_to edit_user_registration_path, notice: "Your phone is saved"
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  def verify_phone_number
    current_user.verify_pin(params[:user][:pin])

    if current_user.phone_verified
      flash[:notice] = "Your phone number is verified"
    else
      flash[:alert] = "Cannot verify your phone number"
    end

    redirect_to edit_user_registration_path

  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  private

  def set_users
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:phone_number, :pin)
  end
end

# 1. to see user needs to be login
# 2. User can see just his own profile -> changed
# =====================================
# 3. twilio - add new or update phone number and generated pin (user_params),
# 4. update routes
