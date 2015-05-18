class AsistenciaController < ApplicationController
  before_action :set_asistencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    respond_to do |format|
      format.html
      format.json { render json: AsistenciaDatatable.new(view_context, { query: Asistencium.all }) }
    end
  end

  def index_personal_activo
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraAsistenciaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def show
    respond_with(@asistencium)
  end

  def new
    @asistencium = Asistencium.new
    respond_with(@asistencium)
  end

  def edit
  end

  def editar_inasistencia_justificada
    debugger
    @asistencia = Asistencium.where(:altas_bajas_hora_id => params["id"])
    if @asistencia.count > 0
      @asistencia.first.update(:ina_justificada => params["post"]["ina_justificada"])
    else
      Asistencium.create(:ina_justificada => params["post"]["ina_justificada"], :altas_bajas_hora_id => params["id"])
    end
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraAsistenciaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def create
    @asistencium = Asistencium.new(asistencium_params)
    @asistencium.save
    respond_with(@asistencium)
  end

  def update
    @asistencium.update(asistencium_params)
    respond_with(@asistencium)
  end

  def destroy
    @asistencium.destroy
    respond_with(@asistencium)
  end

  private
    def set_asistencium
      @asistencium = Asistencium.find(params[:id])
    end

    def asistencium_params
      params.require(:asistencium).permit(:ina_justificada, :ina_injustificada, :ina_total, :lleg_tarde_justificada, :lleg_tarde_injustificada, :lleg_tarde_total, :altas_bajas_hora_id, :altas_bajas_cargo_id)
    end
end
