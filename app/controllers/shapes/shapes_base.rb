class Shapes::ShapesBase < ActionController::Base
  
  protected
  
  def find_shape
    @shape = Shape.find params[:id]
  end

  def find_resource
    @resource = @shape.base.find_by_path params[:path]
  end

end
