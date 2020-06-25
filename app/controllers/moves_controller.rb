class MovesController < ApplicationController

  def edit
    @user=current_user
  end

  def update
    @user=current_user
    filtered_params={}
    ["moving_from", "moving_to", "move_date(1i)", "move_date(2i)", "move_date(3i)"].each { |k| filtered_params[k]=params["user"][k] if params["user"].has_key?(k)}
    Rails.logger.debug("filtered_params=#{filtered_params.inspect}")
    respond_to do |format|
      if @user.update_attributes(filtered_params)
        Rails.logger.debug("OKOKOKOKOK")
        format.html { redirect_to(root_url, :notice => 'Room was successfully updated.') }
      else
        format.html { render :action => "edit" }
      end
    end
  end

end
