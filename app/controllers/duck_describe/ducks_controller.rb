class DuckDescribe::DucksController < ActionController::Base
  
  def index
    @ducks = Duck.find :all
  end
  
  def new
    @duck = Duck.new
  end  
  def create
    @duck = Duck.new params[:duck]
    if @duck.save
      redirect_to ducks_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @duck = Duck.find params[:id]
  end  
  def update
    @duck = Duck.find params[:id]
    @duck.update_attributes params[:duck]
    if @duck.save
      redirect_to ducks_path
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @duck = Duck.find params[:id]
    @duck.destroy unless @duck.nil?
    redirect_to ducks_path
  end
  
  def show
    @duck = Duck.find params[:id]
    @duck.base.install_presenter self
  end 
  
  def xml
    respond_to do |format|
      format.xml do
        @duck = Duck.find_by_name params[:ident]
        @duck.cache_xml
        render :xml => @duck.xml and return false
      end
    end
    render :nothing => true
  end 
end
