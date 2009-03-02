class Shapes::ConstraintsController < Shapes::ShapesBase

  verify :method => :post, :only => [:create, :update]
  
  before_filter :find_shape, :only => [:show, :select, :new, :update, :create, :delete]
  before_filter :find_resource, :only => [:show, :select, :new, :update, :create, :delete]
  
  def show
  end

  def select
  end

  def show_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    @resource.constraints = @struct_primitive.get_constraints
    render :template => "/shapes/constraints/show"
  end
  
  def select_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    render :template => "/shapes/constraints/select_struct"
  end
  
  def new_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    render :template => "shapes/constraints/new_struct_primitive"
  end

  def update_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @constraint = dummy_resource(@struct_primitive).
      find_constraint_by_type params[:type]
    @constraint.update_attributes params[:constraint]
    @sanitized_const_array = @struct_primitive.
      remove_constraint_by_type params[:type]
    @sanitized_const_array << "Shapes::Constraints::#{params[:type]}".
      constantize.new(params[:constraint]).to_s
    @struct_primitive.constraints = @sanitized_const_array
    
    @struct_primitive.save! and redirect_to show_struct_constraints_path(@struct_primitive) or
      render :action => :edit_struct_primitive
  end

  def delete_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    @sanitized_const_array = @struct_primitive.
      remove_constraint_by_type params[:type]
    @struct_primitive.constraints = @sanitized_const_array
    @struct_primitive.save!
    redirect_to show_struct_constraints_path(@struct_primitive)
  end

  def create_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @serialized = params[:type].constantize.new(params[:constraint]).
      to_s
    if @struct_primitive.constraints
      @struct_primitive.constraints = []
    else
      @struct_primitive.constraints = YAML.
        load(@struct_primitive.constraints)
    end
    @struct_primitive.constraints << @serialized
    @struct_primitive.save! and redirect_to show_struct_constraints_path(@struct_primitive) or
      render :action => :new_struct_primitive
     
  end

  def edit_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    @constraint = @resource.find_constraint_by_type params[:type]
  end

  def new
    @constraint = params[:type].constantize.new
  end

  def create
    @constraint = params[:type].constantize.new(params[:constraint])
    @resource.constraints << @constraint
    @shape.save and redirect_to show_constraints_path(@shape, @resource.path) or
      render :action => :new
  end

  def edit
    @constraint = @resource.find_constraint_by_type params[:type]
  end

  def update
    @constraint = @resource.find_constraint_by_type params[:type]
    @constraint.update_attributes params[:constraint]
    @shape.save and redirect_to show_constraints_path(@shape, @resource.path) or
      render :action => :edit
  end

  def delete
    @resource.delete_constraint_by_name params[:type]
    @shape.save and redirect_to show_constraints_path(@shape, @resource.path)
  end
  
  protected

  def dummy_resource(primitive)
    resource = "Shapes::Primitives::#{primitive.primitive}".constantize.new
    resource.constraints = primitive.get_constraints
    resource
  end
end
