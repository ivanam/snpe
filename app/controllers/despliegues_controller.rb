class DesplieguesController < InheritedResources::Base
  before_action :set_despliegue, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: DespliegueDatatable.new(view_context, { query: Despliegue.includes(:plan, :materium) }) }
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
    
    if @despliegue.save
      respond_with(@despliegue.plan)
    else
      respond_with(@despliegue)
    end
  end

  def update
    @despliegue.update(despliegue_params)
    respond_with(@despliegue.plan)
  end

  def destroy
    plan = @despliegue.plan
    @despliegue.destroy
    respond_with(plan)
  end

  private
    def set_despliegue
      @despliegue = Despliegue.find(params[:id])
    end

    def despliegue_params
      params.require(:despliegue).permit(:anio, :plan_id, :materium_id, :carga_horaria, :cant_docentes)
    end
end