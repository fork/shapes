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

  def dup
    @shape = Shape.find params[:id]
  end

  def clone
    @shape = Shape.find(params[:id])
    @clone = Shape.new params[:shape]
    @clone.xml = @shape.base.purged_xml_for_clone.to_s
    if @clone.save
      # reload clone to have shape id in value object
      @clone.reload
      @clone.base.after_clone
      redirect_to shapes_path
    else
      render :action => 'dup'
    end
  end

  def destroy
    @shape = Shape.find params[:id]
    @shape.destroy unless @shape.nil?
    redirect_to shapes_path
  end

  def show
    @shape = Shape.find params[:id]
    respond_to do |format|
      format.html do
        @noscript = true
        render :template => '/shapes/shapes/_show', :layout => true
      end
      format.js { render :partial => '/shapes/shapes/show' }
    end
  end

  def cache
    path = params[:path].collect{ |ident| ident.split('.').first }
    if !path.empty? and resource = Shape.find_by_name(path.first)
      resource = resource.base.find_by_path(path * '#') if path.length > 1
    end
    if resource
      #could not use responder to determine format due to route globbing
      format = params[:path].last.split('.').last
      case format
        when 'json' then render :json => resource.cache_json
        else render :xml => resource.cache_xml
      end
    else
      render :nothing => true, :status => 404
    end
  end

end
