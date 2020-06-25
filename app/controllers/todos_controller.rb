class TodosController < ApplicationController

  before_action :set_todo_and_check_ownership, :only => [:edit, :update, :destroy, :show, :toggle]
  before_action :set_stodos, :onlt => [:suggest_new, :suggest_create]

  # GET /todos
  # GET /todos.xml
  def index
    @todos=current_user.todos.sort { |a,b| a.done == b.done ? a.position <=> b.position : a.done ? 1 : -1 }
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @todos }
    end
  end

  # GET /todos/1
  # GET /todos/1.xml
  def show
    # @todo from set_todo_and_check_ownership

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @todo }
    end
  end

  # GET /todos/new
  # GET /todos/new.xml
  def new
    @todo = Todo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @todo }
    end
  end

  # GET /todos/1/edit
  def edit
    # @todo from set_todo_and_check_ownership
  end

  # POST /todos
  # POST /todos.xml
  def create
    @todo = current_user.todos.build(todo_params())
    respond_to do |format|
      if @todo.save
        format.html { redirect_to(todos_url, :notice => 'Todo was successfully created.') }
        format.xml  { render :xml => @todo, :status => :created, :location => @todo }
        format.js { puts "....... returning js ......"; @id=params[:suggestion][:id]; render }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /todos/1
  # PUT /todos/1.xml
  def update
    # @todo from set_todo_and_check_ownership

    respond_to do |format|
      if @todo.update(todo_params())
        format.html { redirect_to(todos_url, :notice => 'Todo was successfully updated.') }
        format.xml  { head :ok }
        format.js
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @todo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /todos/1
  # DELETE /todos/1.xml
  def destroy
    # @todo from set_todo_and_check_ownership
    @id=params[:id]
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to(todos_url) }
      format.xml  { head :ok }
      format.js
    end
  end

  # POST /todos/
  def sort
    params[:todos].each_with_index do |id, index|
      Todo.update_all(['position=?', index+1], ['id=?', id])
    end
    render :nothing => true
  end
  
  # PUT /todos/1/toggle
  def toggle
    @todo.toggle_done
    respond_to do |format|
      if @todo.save
        format.html { redirect_to(todos_url, :notice => 'Todo was successfully toggled.') }
      else
        format.html { redirect_to(todos_url, :error => 'There was a problem toggling Todo.') }
      end
    end
  end
  
  # GET /todos/suggest
  def suggest_new
  end

  # POST /todos/suggest
  def suggest_create
    gi=params['suggest']['group'].to_i
    puts "stodo=#{@stodos.inspect}"
    todos=@stodos[gi]['todos']
    count=0
    if todos
      todos.each do |todo|
        todo.user = current_user
        if todo.save
          count = count + 1
        end
      end
    end
    if (count==0)
      flash[:error]='No ToDos Created'
    else
      flash[:notice]="Created #{count} new ToDos"
    end
    redirect_to todos_url
  end
  
 private

   # this assumes authenticate_user! already filtered
   def set_todo_and_check_ownership
     @todo = Todo.find(params[:id])
     if (@todo)
       if (@todo.user.id == current_user.id)
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

   def todo_params
     params.require(:todo).permit(:description, :done)

   end

  def set_stodos
    @stodos = Todo.suggest(I18n.locale,current_user.todos.find_all)
  end
end
