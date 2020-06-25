class BoxesController < ApplicationController

  before_action :set_box_and_check_ownership, :only => [:edit, :update, :destroy, :show]
  
  # GET /boxes
  # GET /boxes.pdf
  # GET /boxes.xml
  def index
    @boxes = current_user.boxes.order(sort)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @boxes }
      format.pdf { render :filename=>"box_labels.pdf"}
    end
  end

  # GET /boxes/1
  # GET /boxes/1.pdf
  # GET /boxes/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @box }
      format.pdf { render :filename=>"#{@box.label}_label.pdf"}
    end
  end

  # GET /boxes/new
  # GET /boxes/new.xml
  def new
    @box = Box.new
    @box.label=sprintf("%02d", current_user.boxes.size+1)
    if (params.has_key?("room_id") && (room=Room.find(params["room_id"])) && room.user==current_user)
      @box.room=room
    end
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @box }
    end
  end

  # GET /boxes/1/edit
  def edit
    # @box = Box.find(params[:id])
  end

  # POST /boxes
  # POST /boxes.xml
  def create
    @box = current_user.boxes.build(box_parameters)

    respond_to do |format|
      if @box.save
        format.html { redirect_to(boxes_path, :notice => 'Box was successfully created.') }
        format.xml  { render :xml => @box, :status => :created, :location => @box }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @box.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /boxes/1
  # PUT /boxes/1.xml
  def update
    # @box = Box.find(params[:id])

    respond_to do |format|
      if @box.update_attributes(box_parameters)
        format.html { redirect_to(boxes_path, :notice => 'Box was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @box.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boxes/1
  # DELETE /boxes/1.xml
  def destroy
    # @box = Box.find(params[:id])
    @box.destroy

    respond_to do |format|
      format.html { redirect_to(boxes_url) }
      format.xml  { head :ok }
    end
  end
 private
  # this assumes authenticate_user! already filtered
  def set_box_and_check_ownership
    @box = Box.find(params[:id])
    if (@box)
      if (@box.user.id == current_user.id)
        return true
      else
        flash[:error] = t(:unauthorized)
        redirect_to root_url
        return false
      end
    else
      render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
      return false      
    end
  end
  
  def sort
    k = params[:asort] || params[:dsort]
    return "label DESC" unless k && Box.column_names.include?(k)
    o = params[:asort] ? "ASC" : "DESC"    
    return k=="label" ? "#{k} #{o}" : "#{k} #{o}, label ASC"    
  end

  def box_parameters
    params.require(:box).permit(:label, :description, :fragile, :room_id)
  end
end
