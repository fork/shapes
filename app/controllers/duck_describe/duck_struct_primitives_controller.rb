class DuckDescribe::DuckStructPrimitivesController < ActionController::Base

  layout 'application'

  before_filter :assign_primitive_opts,
    :only => [:edit, :update, :new, :create]

  def new
    @duck_struct = DuckStruct.find params[:duck_struct_id]
    @duck_struct_primitive = DuckStructPrimitive.new(:duck_struct => @duck_struct)
  end

  def create
    @duck_struct = DuckStruct.find params[:duck_struct_id]
    @duck_struct_primitive = DuckStructPrimitive.new params[:duck_struct_primitive]
    @duck_struct_primitive.duck_struct = @duck_struct
    if(@duck_struct_primitive.save)
      redirect_to duck_struct_path(@duck_struct)
    else
      render :action => 'new'
    end
  end

  def edit
    @duck_struct_primitive = DuckStructPrimitive.find params[:id]
  end

  def update
    @duck_struct_primitive = DuckStructPrimitive.find params[:id]
    if(@duck_struct_primitive.update_attributes(params[:duck_struct_primitive]))
      flash[:notice] = 'Duck Struct Primitive was successfully updated.'
      redirect_to duck_struct_path(@duck_struct_primitive.duck_struct)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @duck_struct_primitive = DuckStructPrimitive.find params[:id]
    @duck_struct = @duck_struct_primitive.duck_struct
    if @duck_struct_primitive.destroy
      flash[:notice] = 'Duck Struct Primitive was successfully deleted.'
    else
      flash[:warning] = 'Cannot delete Duck Struct Primitive.'
    end
    redirect_to duck_struct_path(@duck_struct)
  end

  protected
  def assign_primitive_opts
    @primitive_opts = primitive_opts
  end

  def primitive_opts
    DuckDescribe::Primitive.primitives.collect{|primitive|
        [ primitive.name.demodulize, primitive.name.demodulize ]
    }
  end
end
