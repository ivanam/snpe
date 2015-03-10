class EstablecimientosController < ApplicationController
  before_action :set_establecimiento, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: EstablecimientoDatatable.new(view_context) }
    end
  end

  def show
    respond_with(@establecimiento)
  end

  def new
    @establecimiento = Establecimiento.new
    respond_with(@establecimiento)
  end

  def edit
  end

  def create
    @establecimiento = Establecimiento.new(establecimiento_params)
    @establecimiento.save
    respond_with(@establecimiento)
  end

  def update
    @establecimiento.update(establecimiento_params)
    respond_with(@establecimiento)
  end

  def destroy
    @establecimiento.destroy
    respond_with(@establecimiento)
  end

  private
    def set_establecimiento
      @establecimiento = Establecimiento.find(params[:id])
    end

    def establecimiento_params
      params.require(:establecimiento).permit(:codigo_jurisdiccional, :cue, :anexo, :cue_anexo, :sector, :ambito, :nombre, :localidad_id, :domicilio, :responsable, :tipo, :zona, :cuise, :alta, :baja, :dependencia, :email, :isotipo, :nivel_id, :ift, :numero, :privada, :rght, :sistema, :organizacion_id)
    end
end
