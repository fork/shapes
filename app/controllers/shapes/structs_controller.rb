class Shapes::StructsController < ActionController::Base

  layout 'application'

  def index
    @shape_structs = ShapeStruct.find :all
    flash.now[:notice] = "No Shape Structs available" if(@shape_structs.empty?)
  end

  def new
    @shape = Shape.find params[:shape_id] if params[:shape_id]
    @shape_struct = ShapeStruct.new
  end

  def create
    @shape = Shape.find params[:shape_id] if params[:shape_id]
    @shape_struct = ShapeStruct.new params[:shape_struct]
    @shape_struct.shape = @shape
    if @shape_struct.save
      redirect_to shape_structs_path
    else
      render :action => 'new'
    end
  end

  def destroy
    @shape_struct = ShapeStruct.find params[:id]
    if @shape_struct.destroy
      flash[:notice] = 'Shape Struct was successfully deleted.'
    else
      flash[:warning] = 'Cannot delete Shape Struct.'
    end
    redirect_to shape_structs_path
  end

  def show
    @shape_struct = ShapeStruct.find params[:id]
  end
end
