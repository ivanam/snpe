class LicenciaController < ApplicationController
  before_action :set_licencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: LicenciaDatatable.new(view_context, { query: Licencium.all }) }
    end
  end

  def show
    respond_with(@licencium)
  end

  def new
    @licencium = Licencium.new
    respond_with(@licencium)
  end

  def edit
  end

  def create
    debugger
    @licencium = Licencium.new(licencium_params)
    @licencium.save
    respond_with(@licencium)
  end

  def update
    @licencium.update(licencium_params)
    respond_with(@licencium)
  end

  def destroy
    @licencium.destroy
    respond_with(@licencium)
  end

  def cargos_licencia_permitida
    respond_to do |format|
      format.json { render json: CargosLicenciaPermitidaDatatable.new(view_context, { query: Cargo.all}) }
    end
  end

  def altas_bajas_horas_licencia_permitida
    respond_to do |format|
      format.json { render json: AltasBajasHoraLicenciaPermitidaDatatable.new(view_context, { query: AltasBajasHora.all}) }
    end
  end

  def guardar_licencia_horas
    
    @licencia = Licencium.create(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo])
    
    @licencia.save
  end 

  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :altas_bajas_cargo_id, :fecha_desde, :fecha_hasta, :articulo_id)
    end
end
