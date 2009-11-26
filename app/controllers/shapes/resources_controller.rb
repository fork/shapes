class Shapes::ResourcesController < Shapes::ShapesBase

  verify :method => :post, :only => [:create, :update]
  
  before_filter :find_shape, :except => :reorder_resource_with_prototype
  before_filter :find_resource, :only => [:edit, :update, :delete]

  def edit
    @shape = Shape.find params[:id]
    @resource = @shape.base.find_by_path params[:path]
    @resource
  end

  def update
    @resource.update_attributes params[:resource]
    @shape.save and redirect_to shape_path(@shape) or
      render :action => :edit
  end

  def select
    @resource_type_collection = resource_type_hash(@shape)
  end

  def new
    what = params[:type].split(';')
    @resource = "Shapes::Builder::#{what.first.camelize}".
        constantize.new(params.merge({:type => what.last})).build_resource
    parent = @shape.base.find_by_path params[:parent_path]
    parent << @resource
    @resource
  end

  def create
    what = params[:type].split(';')
    @resource = "Shapes::Builder::#{what.first.camelize}".
        constantize.new(params['resource'].merge({:type => what.last})).build_resource
    parent = @shape.base.find_by_path params[:parent_path]
    parent << @resource
    @shape.save and redirect_to shape_path(@shape) or
      render :action => :new
  end

  def delete
    @resource.destroy
    @shape.save
    redirect_to shape_path(@shape)
  end

  def reorder_resource_with_prototype
    shape = Shape.find_by_id params.delete(:shape_id)
    resource = shape.base.find_by_path params.delete(:path)
    ul = params.select {|key, value| key.match(/Ul$/) }.first.last
    resource.sort_children ul
    shape.save
    render :nothing => true
  end

  protected

  def resource_type_hash(shape)
    [ Shapes::SELECT_OPTION_GROUP_STRUCT.new('Primitives', primitive_opts),
      Shapes::SELECT_OPTION_GROUP_STRUCT.new('Global Structs', global_struct_opts),
      Shapes::SELECT_OPTION_GROUP_STRUCT.new('Local Structs', local_struct_opts(shape)),
      Shapes::SELECT_OPTION_GROUP_STRUCT.new('ActiveRecords', record_opts) ]
  end

  def primitive_opts
    Shapes::Primitive.primitives.collect do |primitive|
      Shapes::SELECT_OPTION_STRUCT.new "Primitive;#{primitive.name.demodulize}", primitive.name.demodulize
    end
  end

  def local_struct_opts(shape)
    shape.local_structs.collect do |struct|
      Shapes::SELECT_OPTION_STRUCT.new "Struct;#{struct.name}", struct.name
    end
  end

  def global_struct_opts
    ShapeStruct.global.collect do |struct|
      Shapes::SELECT_OPTION_STRUCT.new "Struct;#{struct.name}", struct.name
    end
  end

  def record_opts
    Shapes.config.keys.collect do |key|
      Shapes::SELECT_OPTION_STRUCT.new "ActiveRecord;#{key}", key
    end
  end
end
