class DuckDescribe::DuckStructsController < ActionController::Base

  layout 'application'

  def index
    @duck_structs = DuckStruct.find :all
    flash.now[:notice] = "No Duck Structs available" if(@duck_structs.empty?)
  end

  def new
    @duck = Duck.find params[:duck_id] if params[:duck_id]
    @duck_struct = DuckStruct.new
  end

  def create
    @duck = Duck.find params[:duck_id] if params[:duck_id]
    @duck_struct = DuckStruct.new params[:duck_struct]
    @duck_struct.duck = @duck
    if @duck_struct.save
      redirect_to duck_structs_path
    else
      render :action => 'new'
    end
  end

  def edit
    @duck_struct = DuckStruct.find params[:id]
  end

  def update
    @duck_struct = DuckStruct.find params[:id]
    if @duck_struct.update_attributes(params[:duck_struct])
      flash[:notice] = 'Duck Struct was successfully updated.'
      redirect_to duck_structs_path
    else
       render :action => 'edit'
    end
  end

  def destroy
    @duck_struct = DuckStruct.find params[:id]
    if @duck_struct.destroy
      flash[:notice] = 'Duck Struct was successfully deleted.'    
    else
      flash[:warning] = 'Cannot delete Duck Struct.'
    end
    redirect_to duck_structs_path
  end

  def show
    @duck_struct = DuckStruct.find params[:id]
  end
end
