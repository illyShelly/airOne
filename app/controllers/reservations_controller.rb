class ReservationsController < ApplicationController
  before_action :authenticate_user!

  def create
    # take room_id from Reservation and get whole Room object
    room = Room.find(params[:room_id])

    # booking available just for travellers not owner
    if current_user == room.user
      flash[:alert] = "You cannot book your own property!"
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      nights = (end_date - start_date).to_i + 1

      @reservation = Reservation.new(reservation_params)
      @reservation.room = room # that's why not needed in params (room_id, user_id)
      @reservation.user = current_user
      @reservation.price = room.price
      @reservation.total = room.price * nights

      if @reservation.save
        flash[:notice] = "Booking was successful"
        # redirect_to room
      else
        render 'reservations/form'
      end
    end
    redirect_to room
  end

  # my personal bookings
  def your_trips
    @trips = current_user.reservations.order(start_date: :asc)
  end

  # bookings made on my rooms
  def your_reservations
    @rooms = current_user.rooms
    @reservations = Reservation.all
  end

  private

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end
end

# other total, price etc. is taken from room object
 # reservations.build -> one user can have all together multiple reservations
      # @reservation = current_user.reservations.build(reservation_params)
      # @reservation.room = @room
      # @reservation.price = @room.price
      # @reservation.total = @room.price * nights
      # @reservation.save
      # flash[:notice] = "Booked Successfully!"
