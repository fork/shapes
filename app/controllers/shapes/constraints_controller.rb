class Shapes::ConstraintsController < Shapes::ShapesBase

  before_filter :find_shape
  before_filter :find_resource

  def show
    respond_to do |format|
      format.html { render :template => 'shapes/constraints/_show', :layout => true }
      format.js { render :partial => 'shapes/constraints/show' }
    end
  end

  def select
    respond_to do |format|
      format.html { render :template => 'shapes/constraints/_select', :layout => true }
      format.js { render :partial => 'shapes/constraints/select' }
    end
  end

  def new_struct_primitive
    @struct_primitive = ShapeStructPrimitive.find(params[:id])
    render :template => "shapes/constraints/new_struct_primitive"
  end

  def new
    @constraint = params[:type].constantize.new
    respond_to do |format|
      format.html { render :template => 'shapes/constraints/_new', :layout => true }
      format.js { render :partial => 'shapes/constraints/new' }
    end
  end

  def create
    @constraint = params[:type].constantize.new(params[:constraint] || {})
    @resource.constraints << @constraint
    if @shape.save
      respond_to do |format|
        format.html { redirect_to show_constraints_path(@shape, @resource.path) }
        format.js { render :partial => 'shapes/constraints/show' }
      end
    else
      respond_to do |format|
        format.html { render :action => :new }
        format.js { render :partial => 'shapes/constraints/new' }
      end
    end
  end

  def edit
    if params[:delete]
      @resource.delete_constraint_by_name params[:type]
      @shape.save
      respond_to do |format|
        format.html { redirect_to show_constraints_path(@shape, @resource.path) }
        format.js { render :partial => 'shapes/constraints/show' }
      end
    else
      @constraint = @resource.find_constraint_by_type params[:type]
      respond_to do |format|
        format.html { render :template => 'shapes/constraints/_edit', :layout => true }
        format.js { render :partial => 'shapes/constraints/edit' }
      end
    end
  end

  def update
    @constraint = @resource.find_constraint_by_type params[:type]
    @constraint.update_attributes params[:constraint]
    if @shape.save
      respond_to do |format|
        format.html { redirect_to show_constraints_path(@shape, @resource.path) }
        format.js { render :partial => 'shapes/constraints/show' }
      end
    else
      respond_to do |format|
        format.html { render :action => :edit }
        format.js { render :partial => 'shapes/constraints/edit' }
      end
    end
  end

  def delete

  end

end
