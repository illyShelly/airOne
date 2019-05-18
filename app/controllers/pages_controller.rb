class PagesController < ApplicationController
  def home
    # show always different rooms on home page -> shuffle, then take 3
    @rooms = Room.where(active: true).shuffle.take(3)
  end

  def search
    # STEP 1 - is something in search and is not empty string; keep 'location of search in session until change'
    if params[:search].present? && params[:search].strip != ""
      session[:loc_search] = params[:search]
    end

    # STEP 2 - searched queary not empty -> show 'active' (published) rooms nearby 5km distance
    if session[:loc_search] && session[:loc_search] != ""
      @rooms_address = Room.where(active: true).near(session[:loc_search], 5, order: 'distance')
    else
      # empty string -> all 'active' rooms
      @rooms_address = Room.where(active: true).all
    end

    # STEP 3 - using ransack -> ticked form attributes applied on found rooms
    @search = @rooms_address.ransack(params[:q])
    @rooms = @search.result

    # result from sansack stored in array variable
    @arrRooms = @rooms.to_a

    # STEP 4 - if checkin/out is chosen
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

      # picked start_date (dd-mm-yy) and parse as Date object
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @rooms.each do |room|
        # ransack result(rooms) => check if not booked in those start_date and end_date (date object)
        # update -> for status = 1 as approved reservation
        not_available = room.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).limit(1)

        if not_available.length > 0
          # remove room if not available
          @arrRooms.delete(room)
        end
      end
    end

  end
end

# active rooms => published
