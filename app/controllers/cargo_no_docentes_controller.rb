class CargoNoDocentesController < InheritedResources::Base
 include ::CargoNoDocentesHelper

	def index
		
   
    if @cargo_no_docente == nil
      @cargo_no_docente = CargoNoDocente.new
    end
    if @persona == nil
      @persona = Persona.new
    end
    @motivo_baja = select_motivo_baja
    @turno = select_turno
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo_no_docente)
  end

  def index_bajas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  def index_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end



  def show
    respond_with(@cargo_no_docente)
  end

  def new
    @cargo = CargoNoDocente.new
    respond_with(@cargo_no_docente)
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
    @persona = Persona.where(nro_documento: @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(tipo_documento_id: @tipo_documento, nro_documento: @dni, nombres: @nombres, apellidos: @apellidos, cuil: @cuil, fecha_nacimiento: @fecha_nacimiento)
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento      
    end

    @cargo_no_docente = CargoNoDocente.new(cargo_no_docente_params)
    @cargo_no_docente.turno = params[:cargo_no_docente][:turno]
    @cargo_no_docente.persona_id = @persona.id
    @cargo_no_docente.establecimiento_id = @establecimiento.id
    @estado = Estado.where(:descripcion => "Ingresado").first

    respond_to do |format|
      if @persona.save then      
          if @cargo_no_docente.save then
            CargoNoDocenteEstado.create(estado_id: @estado.id, cargo_no_docente_id: @cargo_no_docente.id, user_id: current_user.id)
            format.html { redirect_to cargo_no_docentes_path, notice: 'Alta realizada correctamente' }
            format.json { render action: 'show', status: :created, location: @cargo_no_docente }
          else
            format.json { render json: @cargo_no_docente.errors, status: :unprocessable_entity }
            format.html { render action: 'index' }
          end        
      else
          format.json { render json: @persona.errors, status: :unprocessable_entity }
          format.html { render action: 'index' }
      end
    end
  end


  def update
    @cargo_no_docente.update(cargo_no_docente_params)
    respond_with(@cargo_no_docente)
  end

  def destroy
    @cargo_no_docente.destroy
    respond_with(@cargo_no_docente)
  end

  def editar_alta
    @cargo_no_docente = CargoNoDocente.find(params[:id])
    @persona = Persona.find(@cargo.persona_id)
  end

  def guardar_edicion
    @tipo_documento = params["tipo_documento"]
    @dni = params["dni"]
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(nro_documento: @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(tipo_documento_id: @tipo_documento, nro_documento: @dni, nombres: @nombres, apellidos: @apellidos, cuil: @cuil, 
                                fecha_nacimiento: @fecha_nacimiento)
    else
      @persona.assign_attributes({tipo_documento_id: @tipo_documento, nro_documento: @dni, nombres: @nombres, apellidos: @apellidos, cuil: @cuil,
                                  fecha_nacimiento: @fecha_nacimiento})
    end
    @cargo_no_docente = CargoNoDocente.find(params[:id])
    @cargo_no_docente.assign_attributes({ persona_id: @persona.id, secuencia: params[:cargo][:secuencia], fecha_alta: params[:cargo][:fecha_alta], turno: params[:cargo][:turno], observaciones: params[:cargo][:observaciones]})
    respond_to do |format|
      if @persona.save then       
        if @cargo_no_docente.save then
          format.html { redirect_to cargo_no_docentes_path, notice: 'Alta actualizada correctamente' }
          format.json { render action: 'show', status: :created, location: @cargo_no_docente }
        else
          format.html { render action: 'editar_alta' }
          format.json { render json: @cargo_no_docente.errors, status: :unprocessable_entity }
        end        
      else
        format.html { render action: 'editar_alta' }
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end

  end

#------------------------------------------- FUNCIONES COLA ------------------------------------------------------------------------
  def imprimir_cola
    @lote = LoteImpresion.all.where(tipo_id: 2).last
    if @lote.fecha_impresion != nil
      cargo_no_docentes_novedades.where(alta_lote_impresion_id: nil).each do |h|
        if h.estado_actual == "Impreso"
          @novedades_ids << h.id
        end
      end
      @novedades_en_cola_impresion = CargoNoDocente.where(id: @novedades_ids)
      respond_to do |format|
        format.html
        format.json { render json: CargoNoDocentesNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }# ver el helper q lo contiene
      end
    else
      @lote.update(fecha_impresion: Date.today)
      
      respond_to do |format|
        format.html { redirect_to lote_impresion_path(@lote)}
      end
    end
  end

  def cancelar_cola
    @cargo_no_docente = CargoNoDocente.find(params["id"])
    if @cargo_no_docente.estado_anterior == "Chequeado_Baja"
      @estado = Estado.where(descripcion: "Chequeado_Baja").first
      @cargo_no_docente.update(baja_lote_impresion_id: nil)
    elsif @cargo_no_docente.estado_anterior == "Chequeado"
      @estado = Estado.where(descripcion: "Chequeado").first
      @cargo_no_docente.update(alta_lote_impresion_id: nil)
    end
    CargoNoDocenteEstado.create( cargo_no_docente_id: @cargo_no_docente.id, estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargo_no_docentes_index_novedades_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  #------------------------------------------- FUNCIONES DE CAMBIO DE ESTADO ------------------------------------------------------------------------
  
  def cancelar
    @estado = Estado.where(descripcion: "Cancelado").first
    CargoNoDocenteEstado.create( cargo_no_docente_id: params["id"], estado_id: @estado.id, user_id: current_user.id, observaciones: params["cargo_no_docente"]["observaciones"])
    respond_to do |format|
      format.html { redirect_to cargo_no_docentes_path, notice: 'Alta cancelada correctamente' }
      format.json { render json: {status: 'ok'}}
    end
  end

  def chequear
    @estado = Estado.where(descripcion: "Chequeado").first
    CargoNoDocenteEstado.create( cargo_no_docente_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargo_no_docentes_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def dar_baja

    if @cargo_no_docente.update(:fecha_baja => params[:cargo_no_docente][:fecha_baja])
      @estado = Estado.where(:descripcion => "Notificado_Baja").first
      CargoNoDocenteEstado.create(estado_id: @estado.id, cargo_no_docente_id: @cargo_no_docente.id, user_id: current_user.id)
      respond_to do |format|
        format.html { redirect_to cargo_no_docentes_index_bajas_path, notice: 'Baja realizada correctamente' }
        format.json { render json: {status: 'ok'}}
      end
    else
      respond_to do |format|
        format.json { render json: @cargo_no_docente.errors, status: :unprocessable_entity} # 204 No Content
      end
    end
  end

  def notificar
    @estado = Estado.where(descripcion: "Notificado").first 
    CargoNoDocenteEstado.create( cargo_no_docente_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargo_no_docentes_path, notice: 'Alta notificada correctamente' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def imprimir
    respond_to do |format|
      @cargo_no_docente = CargoNoDocente.find(params["id"])
      if @cargo_no_docente.estado_actual == "Chequeado" || @cargo_no_docente.estado_actual == "Chequeado_Baja"
        if @cargo_no_docente.estado_actual == "Impreso"
          format.html { redirect_to cargo_no_docentes_index_novedades_path, alert: 'Ya se encuentra en cola de impresión' }
        else
          @estado = Estado.where(descripcion: "Impreso").first
          @lote_impresion = LoteImpresion.where(fecha_impresion: nil, tipo_id: 2).last
          if @lote_impresion == nil
            @lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil, tipo_id: 2)
          end
          if @cargo_no_docente.estado_actual == "Chequeado"
            @cargo_no_docente.update(alta_lote_impresion_id: @lote_impresion.id)
          elsif @cargo_no_docente.estado_actual == "Chequeado_Baja"
            @cargo_no_docente.update(baja_lote_impresion_id: @lote_impresion.id)
          end
          CargoNoDocenteEstado.create( cargo_no_docente_id: @cargo_no_docente.id, estado_id: @estado.id, user_id: current_user.id)
          format.html { redirect_to cargo_no_docentes_index_novedades_path, notice: 'Se movio la novedad a la cola de impresión' }
        end
      else
        format.html { redirect_to cargo_no_docentes_index_novedades_path, notice: 'No se pudo pasar a impresión' }
      end
      format.json { head :no_content } # 204 No Content
    end
  end

  def cancelar_baja
    if CargoNoDocente.find(params["id"]).estado_actual == "Notificado_Baja"
      if @cargo_no_docente.update(:fecha_baja => nil)
        @estado = Estado.where(descripcion: "Cancelado_Baja").first
        CargoNoDocenteEstado.create( cargo_no_docente_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
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
      if CargoNoDocente.find(params["id"]).estado_actual == "Notificado_Baja"
        @estado = Estado.where(descripcion: "Chequeado_Baja").first
        if CargoNoDocenteEstado.create( cargo_no_docente_id: params["id"], estado_id: @estado.id, user_id: current_user.id) then
          format.json { render json: {status: 'ok', msj: "Baja chequeada correctamente"} }
        else
          format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
        end
      else
        format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
      end
    end
  end

  #--------------------------funciones para datatables------------------

  def cargo_no_docentes_bajas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargoNoDocentesBajasDatatable.new(view_context, { query: cargo_no_docentes_bajas_permitidas }) }
    end
  end

  def cargo_no_docentes_bajas_efectivas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.json { render json: CargoNoDocentesBajasEfectivasDatatable.new(view_context, { query: cargo_no_docentes_bajas_efectivas(@mindate, @maxdate), rol: @rol }) }
    end
  end
  def cargo_no_docentes_nuevos
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargoNoDocentesNuevosDatatable.new(view_context, { query: cargo_no_docentes_nuevos_permitidos(@mindate, @maxdate) }) }
    end
  end

  def cargo_no_docentes_notificados
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.json { render json: CargoNoDocentesNotificadosDatatable.new(view_context, { query: cargo_no_docentes_notificados_permitidos(@mindate, @maxdate), rol: @rol }) }
    end
  end

  def cargo_no_docentes_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargoNoDocentesNovedadesDatatable.new(view_context, { query: cargo_no_docentes_novedades_permitidas(@mindate, @maxdate), :tipo_tabla => "novedades" }) }
    end
  end

  def cola_impresion
    @lote = LoteImpresion.all.where(tipo_id: 2).last
    @novedades_en_cola_impresion =  CargoNoDocente.where(id: -1)
     if @lote != nil then
      if @lote.fecha_impresion == nil
        @novedades_en_cola_impresion = CargoNoDocente.where("alta_lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s)
      end
    end
    respond_to do |format|
      format.html
      format.json { render json: CargosNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
    end
  end


  private

    def cargo_no_docente_params
      params.require(:cargo_no_docente).permit(:establecimiento_id, :persona_id, :cargo, :secuencia, :turno, :fecha_alta, :fecha_baja, :persona_reemplazada_id, :observatorio, :alta_lote_impresion_id_id, :baja_lote_impresion_id, :empresa_id, :lugar_pago_id, :con_movilidad, :ina_injustificadas, :licencia_desde, :licencia_hasta, :cantidad_dias_licencia, :motivo_baja)
    end
end
