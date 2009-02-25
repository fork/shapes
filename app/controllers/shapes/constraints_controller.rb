class Shapes::ConstraintsController < Shapes::ShapesBase

  verify :method => :post, :only => [:create, :update]
  
  before_filter :find_shape, :only => [:show, :select]
  before_filter :find_resource, :only => [:show, :select]
  
  def show
  end

  def show_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    render :template => "/shapes/constraints/show"
  end
  
  def select_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    @resource = dummy_resource(@struct_primitive)
    render :template => "/shapes/constraints/select"
  end
  
  
  def select
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
    resource.constraints = Shapes::Serialization::ConstraintDeserializer.
      new(primitive.constraints).
      deserialize
    resource
  end
end
