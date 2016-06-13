class CargosController < ApplicationController
  before_action :set_cargo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  # ---------------------------------------------- Index -------------------------------------------------------------------------------------------
  def index
    if @cargo == nil
      @cargo = Cargo.new
    end
    if @persona == nil
      @persona = Persona.new
    end
    
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  def index_bajas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  def index_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  # ------------------------------------------------------------------------------------------------------------------------------------------------
  
  def show
    respond_with(@cargo)
  end

  def new
    @cargo = Cargo.new
    respond_with(@cargo)
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

    @cargo = Cargo.new(cargo_params)
    @cargo.situacion_revista = params[:cargo][:situacion_revista]
    @cargo.turno = params[:cargo][:turno]
    @cargo.persona_id = @persona.id
    @cargo.establecimiento_id = @establecimiento.id
    @estado = Estado.where(:descripcion => "Ingresado").first

    respond_to do |format|
      if @persona.save then      
          if @cargo.save then
            CargoEstado.create(estado_id: @estado.id, cargo_id: @cargo.id, user_id: current_user.id)
            format.html { redirect_to cargos_path, notice: 'Alta realizada correctamente' }
            format.json { render action: 'show', status: :created, location: @cargo }
          else
            format.json { render json: @cargo.errors, status: :unprocessable_entity }
            format.html { render action: 'index' }
          end        
      else
          format.json { render json: @persona.errors, status: :unprocessable_entity }
          format.html { render action: 'index' }
      end
    end
  end

  def update
    @cargo.update(cargo_params)
    respond_with(@cargo)
  end

  def destroy
    @cargo.destroy
    respond_with(@cargo)
  end

  def editar_alta
    @cargo = Cargo.find(params[:id])
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
    @cargo = Cargo.find(params[:id])
    @cargo.assign_attributes({ persona_id: @persona.id, secuencia: params[:cargo][:secuencia], fecha_alta: params[:cargo][:fecha_alta],
                              situacion_revista: params[:cargo][:situacion_revista], anio: params[:cargo][:anio], division: params[:cargo][:division],
                              turno: params[:cargo][:turno], observaciones: params[:cargo][:observaciones]})
    respond_to do |format|
      if @persona.save then       
        if @cargo.save then
          format.html { redirect_to cargos_path, notice: 'Alta actualizada correctamente' }
          format.json { render action: 'show', status: :created, location: @cargo }
        else
          format.html { render action: 'editar_alta' }
          format.json { render json: @cargo.errors, status: :unprocessable_entity }
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
      cargos_novedades.where(alta_lote_impresion_id: nil).each do |h|
        if h.estado_actual == "Impreso"
          @novedades_ids << h.id
        end
      end
      @novedades_en_cola_impresion = Cargo.where(id: @novedades_ids)
      respond_to do |format|
        format.html
        format.json { render json: CargosNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
      end
    else
      @lote.update(fecha_impresion: Date.today)
      
      respond_to do |format|
        format.html { redirect_to lote_impresion_path(@lote)}
      end
    end
  end

  def cancelar_cola
    @cargo = Cargo.find(params["id"])
    if @cargo.estado_anterior == "Chequeado_Baja"
      @estado = Estado.where(descripcion: "Chequeado_Baja").first
      @cargo.update(baja_lote_impresion_id: nil)
    elsif @cargo.estado_anterior == "Chequeado"
      @estado = Estado.where(descripcion: "Chequeado").first
      @cargo.update(alta_lote_impresion_id: nil)
    end
    CargoEstado.create( cargo_id: @cargo.id, estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargos_index_novedades_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  #------------------------------------------- FUNCIONES DE CAMBIO DE ESTADO ------------------------------------------------------------------------
  
  def cancelar
    @estado = Estado.where(descripcion: "Cancelado").first
    CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id, observaciones: params["cargo"]["observaciones"])
    respond_to do |format|
      format.html { redirect_to cargos_path, notice: 'Alta cancelada correctamente' }
      format.json { render json: {status: 'ok'}}
    end
  end

  def chequear
    @estado = Estado.where(descripcion: "Chequeado").first
    CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargos_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def dar_baja

    if @cargo.update(:fecha_baja => params[:cargo][:fecha_baja])
      @estado = Estado.where(:descripcion => "Notificado_Baja").first
      CargoEstado.create(estado_id: @estado.id, cargo_id: @cargo.id, user_id: current_user.id)
      respond_to do |format|
        format.html { redirect_to cargos_index_bajas_path, notice: 'Baja realizada correctamente' }
        format.json { render json: {status: 'ok'}}
      end
    else
      respond_to do |format|
        format.json { render json: @cargo.errors, status: :unprocessable_entity} # 204 No Content
      end
    end
  end

  def notificar
    @estado = Estado.where(descripcion: "Notificado").first
    CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargos_path, notice: 'Alta notificada correctamente' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def imprimir
    respond_to do |format|
      @cargo = Cargo.find(params["id"])
      if @cargo.estado_actual == "Chequeado" || @cargo.estado_actual == "Chequeado_Baja"
        if @cargo.estado_actual == "Impreso"
          format.html { redirect_to cargos_index_novedades_path, alert: 'Ya se encuentra en cola de impresión' }
        else
          @estado = Estado.where(descripcion: "Impreso").first
          @lote_impresion = LoteImpresion.where(fecha_impresion: nil, tipo_id: 2).last
          if @lote_impresion == nil
            @lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil, tipo_id: 2)
          end
          if @cargo.estado_actual == "Chequeado"
            @cargo.update(alta_lote_impresion_id: @lote_impresion.id)
          elsif @cargo.estado_actual == "Chequeado_Baja"
            @cargo.update(baja_lote_impresion_id: @lote_impresion.id)
          end
          CargoEstado.create( cargo_id: @cargo.id, estado_id: @estado.id, user_id: current_user.id)
          format.html { redirect_to cargos_index_novedades_path, notice: 'Se movio la novedad a la cola de impresión' }
        end
      else
        format.html { redirect_to cargos_index_novedades_path, notice: 'No se pudo pasar a impresión' }
      end
      format.json { head :no_content } # 204 No Content
    end
  end

  def cancelar_baja
    if Cargo.find(params["id"]).estado_actual == "Notificado_Baja"
      if @cargo.update(:fecha_baja => nil)
        @estado = Estado.where(descripcion: "Cancelado_Baja").first
        CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
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
      if Cargo.find(params["id"]).estado_actual == "Notificado_Baja"
        @estado = Estado.where(descripcion: "Chequeado_Baja").first
        if CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id) then
          format.json { render json: {status: 'ok', msj: "Baja chequeada correctamente"} }
        else
          format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
        end
      else
        format.json { render json: {status: 'error', msj: "No se pudo chequear la baja"} }
      end
    end
  end

  #------------------------------------------- FUNCIONES PARA DATATABLES ----------------------------------------------------------------------------

  def cargos_bajas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargosBajasDatatable.new(view_context, { query: cargos_bajas_permitidas }) }
    end
  end

  def cargos_bajas_efectivas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.json { render json: CargosBajasEfectivasDatatable.new(view_context, { query: cargo_bajas_efectivas(@mindate, @maxdate), rol: @rol }) }
    end
  end

  def cargos_nuevos
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargosNuevosDatatable.new(view_context, { query: cargos_nuevos_permitidos(@mindate, @maxdate) }) }
    end
  end

  def cargos_notificados
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    respond_to do |format|
      format.json { render json: CargosNotificadosDatatable.new(view_context, { query: cargos_notificados_permitidos(@mindate, @maxdate), rol: @rol }) }
    end
  end

  def cargos_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.json { render json: CargosNovedadesDatatable.new(view_context, { query: cargos_novedades_permitidas(@mindate, @maxdate), :tipo_tabla => "novedades" }) }
    end
  end

  def cola_impresion
    @lote = LoteImpresion.all.where(tipo_id: 2).last
    @novedades_en_cola_impresion =  Cargo.where(id: -1)
     if @lote != nil then
      if @lote.fecha_impresion == nil
        @novedades_en_cola_impresion = Cargo.where("alta_lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s)
      end
    end
    respond_to do |format|
      format.html
      format.json { render json: CargosNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
    end
  end

  #---------------------------------------------------------------------------------------------------------------------------------------------------

  private
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    def cargo_params
      params.require(:cargo).permit(:establecimiento_id, :persona_id, :cargo, :secuencia, :situacion_revista, :turno, :anio, :curso, :fecha_alta, :fecha_baja, :persona_reemplazada_id, :observatorio, :alta_lote_impresion_id, :baja_lote_impresion,:empresa_id, :lugar_pago_id, :con_movilidad, :grupo_id, :ina_injustificadas, :licencia_desde, :cargos, :licencia_hasta, :cantidad_dias_licencia, :motivo_baja)
    end
end


