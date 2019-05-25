class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]

  def create
    # take room_id from Reservation and get whole Room object
    room = Room.find(params[:room_id])

    # booking available just for travellers not owner
    if current_user == room.user
      flash[:alert] = "You cannot book your own property!"
    # stripe -> user does not put his credit card yet
    elsif current_user.stripe_id.blank?
      flash[:alert] = "Please, update your payment method."
      # return here otherwise return to room_path at the end of the method
      return redirect_to payment_method_path
    else
      start_date = Date.parse(reservation_params[:start_date])
      end_date = Date.parse(reservation_params[:end_date])
      nights = (end_date - start_date).to_i

      # Once hit button to book room
      @reservation = Reservation.new(reservation_params)
      @reservation.room = room # that's why not needed in params (room_id, user_id)
      @reservation.user = current_user
      @reservation.price = room.price
      @reservation.total = room.price * nights

      # So @reservation.Waiting! actually does 2 things: @reservation.status = 0 (Waiting = 0), @reservation.save
      if @reservation.Waiting!
        # when request booking type
        if room.Request?
          flash[:notice] = "Request was sent"
        else
        # rooms with instant booking
          charge(room, @reservation)
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
    # @reservation.Approved! #change status to approved and saved it to DB
    # redirect_to your_reservations_path
    charge(@reservation.room, @reservation)
    redirect_to your_reservations_path
  end

  def decline
    @reservation.Declined!
    redirect_to your_reservations_path
  end

  private

  def charge(room, reservation)
    # already provided peyment method
    if !reservation.user.stripe_id.blank?
      customer = Stripe::Customer.retrieve(reservation.user.stripe_id)

      charge = Stripe::Charge.create(
        :customer => customer.id,
        :amount => reservation.total * 100, #in cents
        :description => "Room name: #{room.listing_name}, date: #{reservation.start_date.strftime "%Y-%m-%d"} to #{reservation.end_date.strftime "%Y-%m-%d"}",
        :currency => "usd"
        )

      # customer charged -> reservation is changed to approved, otherwise is declined
      if charge
        reservation.Approved!
        flash[:notice] = "Reservation paid successfully!"
      else
        reservation.Declined!
        flash[:alert] = "Cannot provide payment"
      end
    else
    # user does not provide card method -> esp. request booking -> approved by owner -> failed not having stripe added
      flash[:alert] = "You need to provide your payment method first"
      redirect_to your_reservations_path
    end
    rescue Stripe::CardError => e
      reservation.declined!
      flash[:alert] = e.message
  end

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
