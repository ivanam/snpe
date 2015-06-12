class AltasBajasHorasController < ApplicationController
  before_action :set_altas_bajas_hora, only: [:show, :edit, :update, :destroy, :dar_baja]
  load_and_authorize_resource

  def index
    if params["rango"] != nil
      @mindate = params["rango"][0..9]
      @maxdate = params["rango"][13..22]
    else
      @mindate_year = Date.today.year
      @mindate = Date.today.year.to_s + '/' + Date.today.month.to_s + '/01'
      @maxdate = Date.today.end_of_month
    end
    if @altas_bajas_hora == nil
      @altas_bajas_hora = AltasBajasHora.new
    end
    if @persona == nil
      @persona = Persona.new
    end
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas(@mindate.to_date, @maxdate.to_date) }) }
    end
  end

  def index_novedades
    if params["rango"] != nil
      @mindate = params["rango"][0..9]
      @maxdate = params["rango"][13..22]
    else
      @mindate_year = Date.today.year
      @mindate = Date.today.year.to_s + '/' + Date.today.month.to_s + '/01'
      @maxdate = Date.today.end_of_month
    end
    respond_to do |format|
      format.html
      format.json { render json: HorasNovedadesDatatable.new(view_context, { query: horas_novedades(@mindate.to_date, @maxdate.to_date), :tipo_tabla => "novedades" }) }
    end
  end

  def index_notificadas
    if params["rango"] != nil
      @mindate = params["rango"][0..9]
      @maxdate = params["rango"][13..22]
    else
      @mindate_year = Date.today.year
      @mindate = Date.today.year.to_s + '/' + Date.today.month.to_s + '/01'
      @maxdate = Date.today.end_of_month
    end
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraNotificadaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas_notificadas(@mindate.to_date, @maxdate.to_date), rol: @rol }) }
    end
  end

  def index_cola_impresion
    @lote = LoteImpresion.all.last
    if  @lote.fecha_impresion != nil
      @novedades_en_cola_impresion =  AltasBajasHora.where(id: -1)
    else
      #debugger
      #@novedades_en_cola_impresion = AltasBajasHora.where(lote_impresion_id: @lote.id OR baja_lote_impresion_id: @lote.id)
      @novedades_en_cola_impresion = AltasBajasHora.where("lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s)
    end

    respond_to do |format|
      format.html
      format.json { render json: HorasNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
    end
  end

  def index_personal_activo
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def imprimir_cola
    @lote = LoteImpresion.all.last
    if @lote.fecha_impresion != nil
      horas_novedades.where(lote_impresion_id: nil).each do |h|
        if h.estado_actual == "Impreso"
          @novedades_ids << h.id
        end
      end
      @novedades_en_cola_impresion = AltasBajasHora.where(id: @novedades_ids)
      respond_to do |format|
        format.html
        format.json { render json: HorasNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
      end
    else
      @lote.update(fecha_impresion: Date.today)
      
      respond_to do |format|
        format.html { redirect_to lote_impresion_path(@lote)}
        #format.json { render json: HorasNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
      end
    end
  end

  def cancelar_cola
    @hora = AltasBajasHora.find(params["id"])
    if @hora.estado_anterior == "Chequeado_Baja"
      @estado = Estado.where(descripcion: "Chequeado_Baja").first
      @hora.update(baja_lote_impresion_id: nil)
    elsif @hora.estado_anterior == "Chequeado"
      @estado = Estado.where(descripcion: "Chequeado").first
      @hora.update(lote_impresion_id: nil)
    end
    AltasBajasHoraEstado.create( alta_baja_hora_id: @hora.id, estado_id: @estado.id)
    respond_to do |format|
      format.html { redirect_to horas_index_novedades_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def index_bajas
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaPermitidaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def index_bajas_efectivas
    if params["rango"] != nil
      @mindate = params["rango"][0..9]
      @maxdate = params["rango"][13..22]
    else
      @mindate_year = Date.today.year
      @mindate = Date.today.year.to_s + '/' + Date.today.month.to_s + '/01'
      @maxdate = Date.today.end_of_month
    end
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaEfectivaDatatable.new(view_context, { query: altas_bajas_horas_efectivas_bajas(@mindate.to_date, @maxdate.to_date), rol: @rol }) }
    end
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
    @tipo_documento = params["tipo_documento"]
    @dni = params["dni"]
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(:nro_documento => @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(:tipo_documento_id => @tipo_documento, :nro_documento => @dni, :nombres => @nombres, :apellidos => @apellidos, :cuil => @cuil, :fecha_nacimiento => @fecha_nacimiento )
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento      
    end

    @altas_bajas_hora = AltasBajasHora.new(altas_bajas_hora_params)
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.establecimiento_id = @establecimiento.id
    @estado = Estado.where(:descripcion => "Ingresado").first

    respond_to do |format|
      if @persona.save then      
          if @altas_bajas_hora.save then
            AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @altas_bajas_hora.id, user_id: current_user.id)
            format.html { redirect_to altas_bajas_horas_path, notice: 'Alta realizada correctamente' }
            format.json { render action: 'show', status: :created, location: @altas_bajas_hora }
          else
            format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }
            format.html { render action: 'index' }
          end        
      else
          format.json { render json: @persona.errors, status: :unprocessable_entity }
          format.html { render action: 'index' }
      end
    end
  end

  def editar_alta
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    @persona = Persona.find(@altas_bajas_hora.persona_id)
  end

 def guardar_edicion
    @tipo_documento = params["tipo_documento"]
    @dni = params["dni"]
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(:nro_documento => @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(:tipo_documento_id => @tipo_documento, :nro_documento => @dni, :nombres => @nombres, :apellidos => @apellidos, :cuil => @cuil, :fecha_nacimiento => @fecha_nacimiento )
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento    
    end
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.secuencia = params[:altas_bajas_hora][:secuencia]
    @altas_bajas_hora.fecha_alta = params[:altas_bajas_hora][:fecha_alta]
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.horas = params[:altas_bajas_hora][:horas]
    @altas_bajas_hora.ciclo_carrera = params[:altas_bajas_hora][:ciclo_carrera]
    @altas_bajas_hora.anio = params[:altas_bajas_hora][:anio]
    @altas_bajas_hora.division = params[:altas_bajas_hora][:division]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.codificacion = params[:altas_bajas_hora][:codificacion]
    @altas_bajas_hora.oblig = params[:altas_bajas_hora][:oblig]
    @altas_bajas_hora.observaciones = params[:altas_bajas_hora][:observaciones]


    # @altas_bajas_hora = AltasBajasHora.find
    # @altas_bajas_hora.persona_id = @persona.id
    # @altas_bajas_hora.establecimiento_id = @establecimiento.id
   
    respond_to do |format|
      if @persona.save then       
        if @altas_bajas_hora.save then
          format.html { redirect_to altas_bajas_horas_path, notice: 'Alta actualizada correctamente' }
          format.json { render action: 'show', status: :created, location: @altas_bajas_hora }
        else
          format.html { render action: 'editar_alta' }
          #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
          format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }
          #respond_with(@altas_bajas_hora, :location => altas_bajas_horas_path)  
        end        
      else
        format.html { render action: 'editar_alta' }
        #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
        #debugger
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def update
    @altas_bajas_hora.update(altas_bajas_hora_params)
    respond_with(@altas_bajas_hora)
  end

  def destroy
    @altas_bajas_hora.destroy
    respond_with(@altas_bajas_hora)
  end

  def importar
    # Conexion a la base, ya la probe localmente y funciona
    @client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")

    # Aca el result es un conjunto de objetos
    results = @client.query("SELECT * FROM padhc")# where estado='ALT'")     

    #@@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "snpe")
    #results = @@client.query("SELECT * FROM establecimientos LIMIT 0,1000")

    # Recorremos el conjunto de objetos y captura las transacciones
    AltasBajasHora.transaction do
      AltasBajasHoraEstado.transaction do
        results.each do |abh|
          if abh['escuela'] == 724 then
            @establecimiento = Establecimiento.where(:codigo_jurisdiccional => abh['escuela']).first
            @persona = Persona.where(:nro_documento => abh['nume_docu']).first
            if not(@establecimiento == nil or @persona == nil) then
              @data = AltasBajasHora.new(:establecimiento_id => @establecimiento.id, :persona_id => @persona.id, :secuencia => abh['secuencia'], :fecha_alta => abh['fecha_alta'], :fecha_baja => abh['fecha_baja'], :situacion_revista => nil, :horas => abh['hora_cate'], :ciclo_carrera => abh['ciclo'], :anio => abh['curso'], :division => abh['division'], :turno => abh['turno'], :oblig => nil, :observaciones => nil, :horas => abh['horas_cate'], :codificacion => abh['materia'], :situacion_revista => abh['tipo_emp'])
              @data.save!
              @estado = Estado.where(:descripcion => "Ingresado").first
              AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @data.id, user_id: current_user.id)
            end
          end
        end
      end
    end
    respond_to do |format|
      if @data.id != nil
        format.html { redirect_to altas_bajas_horas_path, notice: 'Importacion correcta' }
      else
        format.html { redirect_to altas_bajas_horas_path, alert: 'Importacion incorrecta' }
      end
    end
  end

  def dar_baja
    if @altas_bajas_hora.update(:fecha_baja => params[:altas_bajas_hora][:fecha_baja])
      @estado = Estado.where(:descripcion => "Notificado_Baja").first
      AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @altas_bajas_hora.id, user_id: current_user.id)
      respond_to do |format|
        format.html { redirect_to altas_bajas_horas_index_bajas_path, notice: 'Baja realizada correctamente' }
        format.json { render json: {status: 'ok'}}
      end
    else
      respond_to do |format|
        format.html { redirect_to altas_bajas_horas_index_bajas_path }
        format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity} # 204 No Content
      end
    end
  end

  def cancelar_baja
    if AltasBajasHora.find(params["id"]).estado_actual == "Notificado_Baja"
      if @altas_bajas_hora.update(:fecha_baja => nil)
        @estado = Estado.where(descripcion: "Cancelado_Baja").first
        AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
      end
      respond_to do |format|
        format.json { render json: {status: 'ok', msj: "Baja realizada correctamente"} }
      end
    else
      respond_to do |format|
        format.json { render json: {status: 'error', msj: "No se pudo realizar la baja"} }
      end
    end
  end

  def chequear_baja
    respond_to do |format|
      if AltasBajasHora.find(params["id"]).estado_actual == "Notificado_Baja"
        @estado = Estado.where(descripcion: "Chequeado_Baja").first
        if AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id) then
          format.json { render json: {status: 'ok', msj: "Baja chequeada correctamente"} }
        else
          format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
        end
      else
        format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
      end
    end
  end

  def notificar
    @estado = Estado.where(descripcion: "Notificado").first
    AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta notificada correctamente' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def cancelar
    @estado = Estado.where(descripcion: "Cancelado").first
    AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id, observaciones: params["altas_bajas_hora"]["observaciones"])
    respond_to do |format|
      #format.html { redirect_to altas_bajas_horas_path, alert: 'Alta cancelada correctamente' }
      #format.json { head :no_content } # 204 No Content
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta cancelada correctamente' }
      format.json { render json: {status: 'ok'}}
    end
  end

  def chequear
    @estado = Estado.where(descripcion: "Chequeado").first
    AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def imprimir
    respond_to do |format|
      @hora = AltasBajasHora.find(params["id"])
      if @hora.estado_actual == "Chequeado" || @hora.estado_actual == "Chequeado_Baja"
        if @hora.estado_actual == "Impreso"
          format.html { redirect_to horas_index_novedades_path, alert: 'Ya se encuentra en cola de impresión' }
        else
          @estado = Estado.where(descripcion: "Impreso").first
          @lote_impresion = LoteImpresion.where(fecha_impresion: nil).last
          if @lote_impresion == nil
            @lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil)
          end
          if @hora.estado_actual == "Chequeado"
            @hora.update(lote_impresion_id: @lote_impresion.id)
          elsif @hora.estado_actual == "Chequeado_Baja"
            @hora.update(baja_lote_impresion_id: @lote_impresion.id)
          end
          AltasBajasHoraEstado.create( alta_baja_hora_id: @hora.id, estado_id: @estado.id, user_id: current_user.id)
          format.html { redirect_to horas_index_novedades_path, notice: 'Se movio la novedad a la cola de impresión' }
        end
      else
        format.html { redirect_to horas_index_novedades_path, notice: 'No se pudo pasar a impresión' }
      end
      format.json { head :no_content } # 204 No Content
    end
  end

  def buscar_alta
    if AltasBajasHora.where(:id => params[:id_alta]).count > 0 then
      @alta = AltasBajasHora.where(:id => params[:id_alta]).first
      render json: @alta      
    end
  end

  private
    def set_altas_bajas_hora
      @altas_bajas_hora = AltasBajasHora.find(params[:id])
    end

    def altas_bajas_hora_params
      params.require(:altas_bajas_hora).permit(:establecimiento_id, :mes_periodo, :anio_periodo, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :horas, :ciclo_carrera, :anio, :division, :turno, :codificacion, :oblig, :observaciones)
    end
end
