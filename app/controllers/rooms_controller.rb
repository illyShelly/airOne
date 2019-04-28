class RoomsController < ApplicationController
  before_action :set_room, except: [:index, :new, :create, :delete_attachment]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update]

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
    @photos = @room.images
  end

  def listing
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @photos = @room.images
  end

  def amenities
  end

  def location
  end

  def update

    new_params = room_params
    # when all filled than active change to true => merge for item :active
    new_params = room_params.merge(active: true) if ready_to_display

    if @room.update(new_params)
      # redirect_to :back, notice: "Saved sucessfully"
      flash["notice"] = "Saved sucessfully"
      # redirect_to 'room_listing_path'
    else
      flash["notice"] = "Wasn't updated"
    end
    # redirect back to the current page
    redirect_back(fallback_location: request.referer)
  end


  def delete_attachment
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    # respond_to :js
    redirect_back(fallback_location: request.referer)
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def ready_to_display
    !@room.active && !@room.price.blank? && !@room.listing_name.blank? && @room.images.attached? && !@room.address.blank?
  end

  def is_authorised
    redirect_to root_path, alert: "You don't have permission for this action" unless current_user == @room.user
  end

  def room_params
    params.require(:room).permit(:home_type, :room_type, :accommodate, :bed_room, :bath_room, :listing_name, :summary, :address, :is_tv, :is_kitchen, :is_air, :is_heating, :is_internet, :price, :active, :latitude, :longitude, images:[])
  end
end

# two ways of writing flash info, if combine with redirect_to => run error
# no implicit conversion of Symbol into String
# render :new, alert: "Something went wrong..." DO NOT WORK
# render :new, :flash => { :alert => "Failed to save!" }

# added room_params images[]
# authorised -> secure user data to be changed by other users

# 1. delete method for attached images -> find activestorage id, method plurge
# 2. before_action -> except delete_attachment for set_room
# 3. routes new path for deleter_attachment
# 4. make working AJAX -> name js file as -> the method, use -> respond_to :js??

# 5. secure data of :active room => from room_menu's form
# => room is ready to display if not already activated and fully filled by data
