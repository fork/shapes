class Shapes::ShapesController < ActionController::Base

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
    respond_to do |format|
      format.xml do
        @shape = Shape.find_by_name params[:ident]
        @shape.cache_xml
        render :xml => @shape.xml and return false
      end
    end
    render :nothing => true
  end
end
