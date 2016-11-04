class GruposController < InheritedResources::Base
  before_action :set_grupo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: GrupoDatatable.new(view_context, { query: Grupo.all }) }
    end
  end

  def show
    respond_with(@grupo)
  end

  def new
    @grupo = Grupo.new
    respond_with(@grupo)
  end

  def edit
  end

  def create
    @grupo = Grupo.new(grupo_params)
    @grupo.save
    respond_with(@grupo)
  end

  def update
    @grupo.update(grupo_params)
    respond_with(@grupo)
  end

  def destroy
    @grupo.destroy
    respond_with(@grupo)
  end

  private

  	def set_grupo
      @grupo = Grupo.find(params[:id])
    end

    def grupo_params
      params.require(:grupo).permit(:nombre, :descripcion)
    end
end

