class PlansController < InheritedResources::Base
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: PlanDatatable.new(view_context, { query: Plan.all }) }
    end
  end

  def show
    respond_with(@plan)
  end

  def new
    @plan = Plan.new
    respond_with(@plan)
  end

  def edit
    @plan = Plan.find(params[:id])

  end

  def create
    @plan = Plan.new(plan_params)
    @plan.save
    respond_with(@plan)
  end

  def update
    @plan.update(plan_params)
    respond_with(@plan)
  end

  def destroy
    @plan.destroy
    respond_with(@plan)
  end

  private
    def set_plan
      @plan = Plan.find(params[:id])
    end

    def plan_params
      params.require(:plan).permit(:codigo, :descripcion, :nivel_id, :resolucion, :tipo_plan_id, establecimientos_plans_attributes: [:id, :establecimiento_id, :_destroy])
    end
end

