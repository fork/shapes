class Shapes::ShapesController < Shapes::ShapesBase

  def index
    @shapes = Shape.find :all
  end
  def new
    @shape = Shape.new
  end
  def create
    @shape = Shape.new params[:shape]
    if @shape.save
      redirect_to shapes_path
    else
      render :action => 'new'
    end
  end

  def edit
    @shape = Shape.find params[:id]
  end
  def update
    @shape = Shape.find params[:id]
    @shape.update_attributes params[:shape]
    if @shape.save
      redirect_to shapes_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @shape = Shape.find params[:id]
    @shape.destroy unless @shape.nil?
    redirect_to shapes_path
  end

  def show
    @shape = Shape.find params[:id]
    @shape.base.install_presenter self
  end

  def xml
    path = params[:path].collect{|ident| ident.gsub(/\.xml/, '')} || nil
    @shape = Shape.find_by_name path.first
    if path.empty? && @shape
      xml = @shape.cache_xml
    elsif !path.blank? && @shape
      resource = @shape.base.find_by_path(path * '#')
      xml = resource.cache_xml if resource
    end
    xml ? render(:xml => xml) :
      render(:text => '', :status => 404)
  end
end
