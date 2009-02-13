class Shapes::ConstraintsController < Shapes::ShapesBase

  verify :method => :post, :only => [:create, :update]
  
  before_filter :find_shape
  before_filter :find_resource

  def show
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

end
