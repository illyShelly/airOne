class RoomsController < ApplicationController
  before_action :set_room, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]

  def index
    # all rooms belongs to particular user
    @rooms = current_user.rooms
  end

  def new
    @room = current_user.rooms.build
  end

  def create
    @room = current_user.rooms.build(room_params)
      # rooms/id/listings
    if @room.save
      # flash[:notice] = "Saved successfully"
      # redirect_to listing_room_path(@room)
      redirect_to listing_room_path(@room), flash: { notice: "Saved successfully" }
    else
      flash[:alert] = "Something went wrong ..."
      # render :new, alert: "Something went wrong..." does not work
      render :new
      # render :new, :flash => { :alert => "Failed to delete!" }
    end
  end

  def show
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
  end

  def amenities
  end

  def location
  end

  def update
    if @room.update(room_params)
      # redirect_to :back, notice: "Saved sucessfully"
      flash["notice"] = "Saved sucessfully"
      # redirect_to 'room_listing_path'
    else
      flash["notice"] = "Wasn't updated"
    end
    # redirect back to the current page
    redirect_back(fallback_location: request.referer)
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, :is_heating, :is_internet, :price, :active)
  end
end

# two ways of writing flash info, if combine with redirect_to => run error
# no implicit conversion of Symbol into String
# render :new, alert: "Something went wrong..." DO NOT WORK
# render :new, :flash => { :alert => "Failed to save!" }
