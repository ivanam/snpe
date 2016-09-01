class EstablecimientoPlansController < InheritedResources::Base
  before_action :set_establecimiento_plan, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: EstablecimientoPlanDatatable.new(view_context, { query: EstablecimientoPlan.includes(:establecimiento, :plan) }) }
    end
  end

  def show
    respond_with(@establecimiento_plan)
  end

  def new
    @establecimiento_plan = EstablecimientoPlan.new
    respond_with(@establecimiento_plan)
  end

  def edit
  end

  def create
    @establecimiento_plan = EstablecimientoPlan.new(establecimiento_plan_params)
    @establecimiento_plan.save
    respond_with(@establecimiento_plan)
  end

  def update
    @establecimiento_plan.update(establecimiento_plan_params)
    respond_with(@establecimiento_plan)
  end

  def destroy
    @establecimiento_plan.destroy
    respond_with(@establecimiento_plan)
  end

  private
    def set_establecimiento_plan
      @establecimiento_plan = EstablecimientoPlan.find(params[:id])
    end

    def establecimiento_plan_params
      params.require(:establecimiento_plan).permit(:establecimiento_id, :plan_id)
    end
end

