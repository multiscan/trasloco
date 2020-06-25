class RoomsController < ApplicationController

  before_action :set_room_and_check_ownership, :only => [:edit, :update, :destroy, :show]

  # GET /rooms
  # GET /rooms.xml
  def index
    @rooms = current_user.rooms

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @rooms }
      format.pdf { render :filename=>"room_labels.pdf"}
    end
  end

  # GET /rooms/1
  # GET /rooms/1.pdf
  def show
    @room = Room.find(params[:id])    
    respond_to do |format|
      format.html do 
        @boxes=@room.boxes.sort { |a,b| b.label <=> a.label } if (@room.boxes.size>0)
      end
      format.pdf do 
        @boxes=Array.new
        r1 = Box.new({:room=>@room, :fragile=>true, :label=>nil})
        r2 = Box.new({:room=>@room, :fragile=>false, :label=>nil})
        2.times do
          @boxes << r1
        end
        6.times do
          @boxes << r2 
        end
        p @boxes
        render :template => 'boxes/index', :layout => 'boxes', formats: [:pdf]
      end
    end
  end

  # GET /rooms/new
  # GET /rooms/new.xml
  def new
    # alpha="A B C D E F G H I J K L M N O P Q R S T U V X Y Z".split(" ")
    # @room = Room.new({:floor=>0, :label=>alpha[current_user.rooms.size]})
    @room = Room.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @room }
    end
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.xml
  def create
    @room = current_user.rooms.build(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to(rooms_path, :notice => 'Room was successfully created.') }
        format.xml  { render :xml => @room, :status => :created, :location => @room }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /rooms/1
  # PUT /rooms/1.xml
  def update
    respond_to do |format|
      if @room.update_attributes(room_params)
        format.html { redirect_to(rooms_path, :notice => 'Room was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.xml
  def destroy
    @room.destroy

    respond_to do |format|
      format.html { redirect_to(rooms_url) }
      format.xml  { head :ok }
    end
  end
 private
  # this assumes authenticate_user! already filtered
  def set_room_and_check_ownership
    @room = Room.find(params[:id])
    if (@room)
      if (@room.user.id == current_user.id)
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

  def room_params
    params.require(:room).permit(:floor, :name, :label)
  end
  
end
