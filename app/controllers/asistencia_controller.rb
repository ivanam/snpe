class AsistenciaController < ApplicationController
  before_action :set_asistencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  #---------------------------------------------- Páginas de inicio de asistencia ---------------------------------------------------------------------------

  def index
    
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    asistencia = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_hora_id: nil).first
    @puede_informar = true
    if asistencia != nil
      @puede_informar = not(asistencia.estado_actual == "Notificado")
    end
    respond_to do |format|
      format.html
    end
  end

  def index_cargo
    
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    asistencia = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_cargo_id: nil).first
    @puede_informar = true
    if asistencia != nil
      @puede_informar = not(asistencia.estado_actual == "Notificado")
    end
    respond_to do |format|
      format.html
    end
  end

  def index_cargo_no_docente
    
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    asistencia = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_cargo_no_docente_id: nil).first
    @puede_informar = true
    if asistencia != nil
      @puede_informar = not(asistencia.estado_actual == "Notificado")
    end
    respond_to do |format|
      format.html
    end
  end

  def index_novedades_alta_baja_hora
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.html
    end
  end

  def index_novedades_cargo
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.html
    end
  end

  def index_novedades_cargo_no_docente
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.html
    end
  end

  

  #--------------------------------------------- Funciones para Datatables ----------------------------------------------------------------------------------

  def index_personal_activo
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraAsistenciaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas, anio: @anio, mes:@mes }) }
    end
  end

  def personal_cargo
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.json { render json: CargoAsistenciaDatatable.new(view_context, { query: cargos_bajas_permitidas, anio: @anio, mes:@mes }) }
    end
  end

  def personal_cargo_no_docente
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.json { render json: CargoNoDocenteAsistenciaDatatable.new(view_context, { query: cargo_no_docentes_bajas_permitidas, anio: @anio, mes:@mes }) }
    end
  end

  def novedades_hora
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.json { render json: AltasBajasHoraAsistenciaDatatable.new(view_context, { query: asistencia_horas_notificados(@anio, @mes), anio: @anio, mes:@mes }) }
    end
  end

  def novedades_cargo
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.json { render json: CargoAsistenciaDatatable.new(view_context, { query: asistencia_cargos_notificados(@anio, @mes), anio: @anio, mes:@mes }) }
    end
  end

  def novedades_cargo_no_docente
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    respond_to do |format|
      format.json { render json: CargoNoDocenteAsistenciaDatatable.new(view_context, { query: asistencia_cargo_no_docentes_notificados(@anio, @mes), anio: @anio, mes:@mes }) }
    end
  end

  #----------------------------------------------- Funciones de cambio de estado ----------------------------------------------------------------------------
  def altas_bajas_horas_informar
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    @estado = Estado.where(descripcion: "Notificado").first
    @asistencias = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_hora_id: nil)
    @asistencias.each do |a|
      AsistenciaEstado.create( asistencia_id: a.id, estado_id: @estado.id, user_id: current_user.id)
    end
    respond_to do |format|
      format.html { redirect_to asistencia_index_path}
    end
  end

  def cargos_informar
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    @estado = Estado.where(descripcion: "Notificado").first
    @asistencias = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_cargo_id: nil)
    @asistencias.each do |a|
      AsistenciaEstado.create( asistencia_id: a.id, estado_id: @estado.id, user_id: current_user.id)
    end
    respond_to do |format|
      format.html { redirect_to asistencia_index_cargo_path}
    end
  end

  def cargo_no_docentes_informar
    @anio, @mes = Util.anio_mes_periodo(params["anio"], params["mes"])
    @estado = Estado.where(descripcion: "Notificado").first
    @asistencias = Asistencium.where(anio_periodo: @anio, mes_periodo: @mes).where.not(altas_bajas_cargo_no_docente_id: nil)
    @asistencias.each do |a|
      AsistenciaEstado.create( asistencia_id: a.id, estado_id: @estado.id, user_id: current_user.id)
    end
    respond_to do |format|
      format.html { redirect_to asistencia_index_cargo_no_docente_path}
    end
  end

  #----------------------------------------------------------------------------------------------------------------------------------------------------------
  def show
    respond_with(@asistencium)
  end

  def new
    @asistencium = Asistencium.new
    respond_with(@asistencium)
  end

  def edit
  end

  def editar_asistencia
    anio = params["anio"]
    mes = params["mes"]
    @asistencia = Asistencium.where(altas_bajas_hora_id: params["id"], anio_periodo: anio, mes_periodo: mes)
    if @asistencia.count > 0
      if params["post"]["ina_justificada"] != nil
        @asistencia.first.update(ina_justificada: params["post"]["ina_justificada"])
      end 
      if params["post"]["ina_injustificada"] != nil
        @asistencia.first.update(ina_injustificada: params["post"]["ina_injustificada"])
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        @asistencia.first.update(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"])
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        @asistencia.first.update(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"])
      end
    else
      if params["post"]["ina_justificada"] != nil
        Asistencium.create(ina_justificada: params["post"]["ina_justificada"], altas_bajas_hora_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end 
      if params["post"]["ina_injustificada"] != nil
        Asistencium.create(ina_injustificada: params["post"]["ina_injustificada"], altas_bajas_hora_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        Asistencium.create(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"], altas_bajas_hora_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        Asistencium.create(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"], altas_bajas_hora_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraAsistenciaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def editar_asistencia_cargo
    anio = params["anio"]
    mes = params["mes"]
    @asistencia = Asistencium.where(altas_bajas_cargo_id: params["id"], anio_periodo: anio, mes_periodo: mes)
    if @asistencia.count > 0
      if params["post"]["ina_justificada"] != nil
        @asistencia.first.update(ina_justificada: params["post"]["ina_justificada"])
      end 
      if params["post"]["ina_injustificada"] != nil
        @asistencia.first.update(ina_injustificada: params["post"]["ina_injustificada"])
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        @asistencia.first.update(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"])
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        @asistencia.first.update(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"])
      end
    else
      if params["post"]["ina_justificada"] != nil
        Asistencium.create(ina_justificada: params["post"]["ina_justificada"], altas_bajas_cargo_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end 
      if params["post"]["ina_injustificada"] != nil
        Asistencium.create(ina_injustificada: params["post"]["ina_injustificada"], altas_bajas_cargo_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        Asistencium.create(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"], altas_bajas_cargo_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        Asistencium.create(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"], altas_bajas_cargo_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
    end

    respond_to do |format|
      format.json { render json: CargoAsistenciaDatatable.new(view_context, { query: cargos_bajas_permitidas }) }
    end
  end

  def editar_asistencia_cargo_no_docente
    anio = params["anio"]
    mes = params["mes"]
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: params["id"], anio_periodo: anio, mes_periodo: mes)
    if @asistencia.count > 0
      if params["post"]["ina_justificada"] != nil
        @asistencia.first.update(ina_justificada: params["post"]["ina_justificada"])
      end 
      if params["post"]["ina_injustificada"] != nil
        @asistencia.first.update(ina_injustificada: params["post"]["ina_injustificada"])
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        @asistencia.first.update(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"])
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        @asistencia.first.update(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"])
      end
    else
      if params["post"]["ina_justificada"] != nil
        Asistencium.create(ina_justificada: params["post"]["ina_justificada"], altas_bajas_cargo_no_docente_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end 
      if params["post"]["ina_injustificada"] != nil
        Asistencium.create(ina_injustificada: params["post"]["ina_injustificada"], altas_bajas_cargo_no_docente_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_justificada"] != nil
        Asistencium.create(lleg_tarde_justificada: params["post"]["lleg_tarde_justificada"], altas_bajas_cargo_no_docente_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
      if params["post"]["lleg_tarde_injustificada"] != nil
        Asistencium.create(lleg_tarde_injustificada: params["post"]["lleg_tarde_injustificada"], altas_bajas_cargo_no_docente_id: params["id"], anio_periodo: anio, mes_periodo: mes)
      end
    end

    respond_to do |format|
      format.json { render json: CargoNoDocenteAsistenciaDatatable.new(view_context, { query: cargo_no_docentes_bajas_permitidas }) }
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
