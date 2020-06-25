class HomeController < ApplicationController
  def index
    # if user_signed_in?
    #   redirect_to dashboard_path
    # else
    #   redirect_to new_user_session_url
    # end 
  end
  
  def dashboard
    @rooms = current_user.rooms
  end
end
