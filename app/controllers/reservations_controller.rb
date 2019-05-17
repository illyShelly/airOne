class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

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
        # when request booking type
        if room.Request?
          flash[:notice] = "Request was sent"
        else
        # when instant booking
        # @reservation.Approved! <=> @reservation.status = 1, @reservation.save
          @reservation.Approved!
          flash[:notice] = "Booking was approved successfully"
        end
      else
        flash[:alert] = "Cannot make a new reservation"
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

  def approve
    @reservation.Approved! #change status to approved and saved it to DB
    redirect_to your_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_reservations_path
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id]);
  end

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
# ==================================================
# decline or accept request booking - set reservation, methods -> routes
