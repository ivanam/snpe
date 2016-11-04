class EmpresasController < InheritedResources::Base
  before_action :set_empresa, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: EmpresaDatatable.new(view_context, { query: Empresa.all }) }
    end
  end

  def show
    respond_with(@empresa)
  end

  def new
    @empresa = Empresa.new
    respond_with(@empresa)
  end

  def edit
  end

  def create
    @empresa = Empresa.new(empresa_params)
    @empresa.save
    respond_with(@empresa)
  end

  def update
    @empresa.update(empresa_params)
    respond_with(@empresa)
  end

  def destroy
    @empresa.destroy
    respond_with(@empresa)
  end

  private

  	def set_empresa
      @empresa = Empresa.find(params[:id])
    end

    def empresa_params
      params.require(:empresa).permit(:nombre, :descripcion)
    end
end

