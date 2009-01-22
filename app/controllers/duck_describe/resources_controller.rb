class DuckDescribe::ResourcesController < ActionController::Base

  verify :method => :post, :only => [:create, :update]

  def edit
    @duck = Duck.find params[:id]
    @resource = @duck.base.find_by_path params[:path]
    @resource.install_presenter(self)
  end

  def update
    @duck = Duck.find params[:id]
    @resource = @duck.base.find_by_path params[:path]
    @resource.update_attributes params[:resource]
    @duck.save and redirect_to duck_path(@duck) or 
      (@resource.install_presenter(self) and render :action => :edit)
  end

  def select
    @duck = Duck.find params[:id]
    @resource_type_collection = resource_type_hash
  end

  def new
    @duck = Duck.find params[:id]
    what = params[:type].split(';')
    @resource = "DuckDescribe::Builder::#{what.first.camelize}".
        constantize.new(params.merge({:type => what.last})).build_resource
    @resource.install_presenter(self)
  end

  def create
    @duck = Duck.find params[:id]
    what = params[:type].split(';')
    @resource = "DuckDescribe::Builder::#{what.first.camelize}".
        constantize.new(params['resource'].merge({:type => what.last})).build_resource
    parent = @duck.base.find_by_path params[:parent_path]
    parent << @resource
    @duck.save and redirect_to duck_path(@duck) or 
      (@resource.install_presenter(self) and render :action => :new)
  end

  def delete
    duck = Duck.find params[:id]
    resource = duck.base.find_by_path params[:path]
    resource.destroy
    duck.save and redirect_to duck_path(duck)
  end

  protected
  def resource_type_hash
    [ DuckDescribe::OPT_GROUP_STRUCT.new('Primitives', primitive_opts),
      DuckDescribe::OPT_GROUP_STRUCT.new('Structs', struct_opts),
      DuckDescribe::OPT_GROUP_STRUCT.new('ActiveRecords', record_opts) ]
  end

  def primitive_opts
    DuckDescribe::Primitive.primitives.collect do |primitive|
      DuckDescribe::OPT_STRUCT.new "Primitive;#{primitive.name.demodulize}", primitive.name.demodulize
    end
  end

  def struct_opts
    DuckStruct.find(:all).collect do |struct|
      DuckDescribe::OPT_STRUCT.new "Struct;#{struct.name}", struct.name
    end
  end

  def record_opts
    DuckDescribe.config.keys.collect do |key|
      DuckDescribe::OPT_STRUCT.new "ActiveRecord;#{key}", key
    end
  end
end
