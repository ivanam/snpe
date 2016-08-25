class DesplieguesController < InheritedResources::Base
  before_action :set_despliegue, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: DespliegueDatatable.new(view_context, { query: Despliegue.all }) }
    end
  end

  def show
    respond_with(@despliegue)
  end

  def new
    @despliegue = Despliegue.new
    respond_with(@despliegue)
  end

  def edit
  end

  def create
    @despliegue = Despliegue.new(despliegue_params)
    @despliegue.save
    respond_with(@despliegue)
  end

  def update
    @despliegue.update(despliegue_params)
    respond_with(@despliegue)
  end

  def destroy
    @despliegue.destroy
    respond_with(@despliegue)
  end

  private
    def set_despliegue
      @despliegue = Despliegue.find(params[:id])
    end

    def despliegue_params
      params.require(:despliegue).permit(:anio, :plan_id, :materia_id, :carga_horaria)
    end
end

