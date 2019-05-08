class HostReviewsController < ApplicationController
  def create
    # current_user represents by host_id

    # Step 1: Check if the 'RESERVATION' exist (room_id, guest_id, host_id - we use hidden field)
    # Step 2: Check if the current host already REVIEWED the guest in this reservation
    @reservation = Reservation.where(
      id: host_review_params[:reservation_id],
      room_id: host_review_params[:room_id],
      user_id: host_review_params[:guest_id]
      ).first

    # BOOKING exists -> can make review
    if !@reservation.nil?
      # check whether review exists in DB
      @has_reviewed = HostReview.where(
        reservation_id: @reservation.id,
        guest_id: host_review_params[:guest_id]
        ).first

      # write new review
      if @has_reviewed.nil?
        # Allow to review
        @host_review = current_user.host_reviews.create(host_review_params)
        flash[:success] = "Review was created"
      else
        # Already reviewed -> info
        flash[:success] = "You already reviewed this trip"
      end

    # BOOKING does not exist
    else
      flash[:alert] = "Not found this reservation"
    end
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy

    redirect_back(fallback_location: request.referer, notice: "Review was removed.")
  end

  private

  def host_review_params
    params.require(:host_review).permit(:comment, :star, :room_id, :reservation_id, :guest_id)
  end
end
