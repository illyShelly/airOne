class CalendarsController < ApplicationController
  before_action :authenticate_user!
  include ApplicationHelper # for email signin users-> without image

  def host
    # show all owners rooms
    @rooms = current_user.rooms

    # if start_date is empty assign current date in string (instead Date time type )
    params[:start_date] ||= Date.current.to_s
    # if user does not have any room => assign nil, otherwise first room with it's 'id'
    params[:room_id] ||= @rooms[0] ? @rooms[0].id : nil

    # Solve to show more rooms -> using ransack from dropdown menu
    if params[:q].present?
      params[:start_date] = params[:q][:start_date]
      params[:room_id] = params[:q][:room_id]
    end
    @search = Reservation.ransack(params[:q])

    if params[:room_id]
      @room = Room.find(params[:room_id])
      # parse data in Date format
      start_date = Date.parse(params[:start_date])

      # show month before start_date (from 1st of month) and month after (count from 1st of month)
      # we want 3 months period of time
      # otherwise (start_date).beginning_of_month -> would return (1 May), not 1 month more
      first_of_month = (start_date - 1.months).beginning_of_month # if May => return April 1
      end_of_month = (start_date + 1.months).end_of_month # => June 31

      # looking for all reservations of particular room + user's table info (guest of that room)
      # not used users* -> that we've got all data, not just some
      # show +/- month from start_date , except declined bookings => status: { Waiting: 0, Approved: 1, Declined: 2}
      @events = @room.reservations.joins(:user)
                .select('reservations.*, users.fullname, users.image, users.email, users.uid')
                .where('(start_date BETWEEN ? AND ?) AND status <> ?', first_of_month, end_of_month, 2)

      @events.each { |e| e.image = avatar_url(e)}
    else
      @room = nil
      @events = []
    end

  end
end
