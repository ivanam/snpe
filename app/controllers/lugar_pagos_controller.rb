class LugarPagosController < InheritedResources::Base
  before_action :set_lugar_pago, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: LugarPagoDatatable.new(view_context, { query: LugarPago.all }) }
    end
  end

  def show
    respond_with(@lugar_pago)
  end

  def new
    @lugar_pago = LugarPago.new
    respond_with(@lugar_pago)
  end

  def edit
  end

  def create
    @lugar_pago = LugarPago.new(lugar_pago_params)
    @lugar_pago.save
    respond_with(@lugar_pago)
  end

  def update
    @lugar_pago.update(lugar_pago_params)
    respond_with(@lugar_pago)
  end

  def destroy
    @lugar_pago.destroy
    respond_with(@lugar_pago)
  end

  private

  	def set_lugar_pago
      @lugar_pago = LugarPago.find(params[:id])
    end

    def lugar_pago_params
      params.require(:lugar_pago).permit(:codigo, :descripcion)
    end
end

