class Shapes::StructPrimitivesController < ActionController::Base

  layout 'application'

  before_filter :assign_primitive_opts,
    :only => [:edit, :update, :new, :create]

  def new
    @shape_struct = ShapeStruct.find params[:shape_struct_id]
    @shape_struct_primitive = ShapeStructPrimitive.new(:shape_struct => @shape_struct)
  end

  def create
    @shape_struct = ShapeStruct.find params[:shape_struct_id]
    @shape_struct_primitive = ShapeStructPrimitive.new params[:shape_struct_primitive]
    @shape_struct_primitive.shape_struct = @shape_struct
    if(@shape_struct_primitive.save)
      redirect_to shape_struct_path(@shape_struct)
    else
      render :action => 'new'
    end
  end

  def destroy
    @shape_struct_primitive = ShapeStructPrimitive.find params[:id]
    @shape_struct = @shape_struct_primitive.shape_struct
    if @shape_struct_primitive.destroy
      flash[:notice] = 'Shape Struct Primitive was successfully deleted.'
    else
      flash[:warning] = 'Cannot delete Shape Struct Primitive.'
    end
    redirect_to shape_struct_path(@shape_struct)
  end

  protected
  def assign_primitive_opts
    @primitive_opts = primitive_opts
  end

  def primitive_opts
    Shapes::Primitive.primitives.collect{|primitive|
        [ primitive.name.demodulize, primitive.name.demodulize ]
    }
  end
end
