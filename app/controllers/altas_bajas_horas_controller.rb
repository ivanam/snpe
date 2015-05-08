class AltasBajasHorasController < ApplicationController
  before_action :set_altas_bajas_hora, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @altas_bajas_horas = AltasBajasHora.all
    respond_with(@altas_bajas_horas)
  end

  def show
    respond_with(@altas_bajas_hora)
  end

  def new
    @altas_bajas_hora = AltasBajasHora.new
    respond_with(@altas_bajas_hora)
  end

  def edit
  end

  def create
    debugger
    @altas_bajas_hora = AltasBajasHora.new(altas_bajas_hora_params)
    @altas_bajas_hora.save
    respond_with(@altas_bajas_hora)
  end

  def update
    @altas_bajas_hora.update(altas_bajas_hora_params)
    respond_with(@altas_bajas_hora)
  end

  def destroy
    @altas_bajas_hora.destroy
    respond_with(@altas_bajas_hora)
  end

  private
    def set_altas_bajas_hora
      @altas_bajas_hora = AltasBajasHora.find(params[:id])
    end

    def altas_bajas_hora_params
      params.require(:altas_bajas_hora).permit(:establecimiento_id, :mes_periodo, :anio_periodo, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :horas, :ciclo_carrera, :anio, :division, :turno, :codificacion, :oblig, :observaciones)
    end
end
