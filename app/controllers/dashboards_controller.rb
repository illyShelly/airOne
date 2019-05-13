class DashboardsController < ApplicationController
  before_action :authenticate_user!

  # current user rooms
  def index
    @rooms = current_user.rooms
  end
end

# change default behaviour for sign-in path app controller -> for redirect when signin
