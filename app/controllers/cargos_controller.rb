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
    @motivo_baja = select_motivo_baja
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  def index_bajas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_with(@cargo)
  end

  def index_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.html
      format.json { render json: CargosNovedadesDatatable.new(view_context, { query: cargos_novedades_permitidas(@mindate, @maxdate), :tipo_tabla => "novedades" }) }
    end
  end

  # ------------------------------------------------------------------------------------------------------------------------------------------------
  
  def show
    @cargos = Cargo.find(params[:id])
  end

  def show
    @cargos = Cargo.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        #:template => 'entradas/show.html.erb',
        :template => 'cargos/pdf.html.erb',
        #:layout => 'application.html.erb',
        :layout => 'pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end

  def new
    @cargo = Cargo.new
    respond_with(@cargo)
  end

  def edit
  end

  def create
    tipo_documento = params["tipo_documento"]
    @sexo = params["sexo"]
    @dni = params["dni"]
    apeynom = params["apeynom"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(nro_documento: @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(tipo_documento_id: tipo_documento, sexo_id: @sexo, nro_documento: @dni, apeynom: @apeynom, cuil: @cuil, fecha_nacimiento: @fecha_nacimiento)
    else
      @persona.tipo_documento_id = tipo_documento
      @persona.sexo_id = @sexo
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apeynom = apeynom
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento      
    end

    @cargo = Cargo.new(cargo_params)
    @cargo.situacion_revista = params[:cargo][:situacion_revista]
    @cargo.turno = params[:cargo][:turno]
    @cargo.con_movilidad = params[:cargo][:con_movilidad]
    @cargo.persona_id = @persona.id
    @cargo.estado = "ALT"
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
    @cargo = Cargo.find(params[:id])    
    @cargo.estados.destroy_all
    @cargo.destroy

    respond_to do |format|
      format.html { redirect_to cargos_url, notice: 'Se ha eliminado la carga' }
      format.json { head :no_content }
    end
  end


  def persona_por_cargo
    @altas_escuela = Cargo.where(:establecimiento_id => session[:establecimiento], cargo_id: params[:cargo_id])
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraMateriaDatatable.new(view_context, { query: @altas_escuela }) }
    end
  end

  def editar_alta
    @cargo = Cargo.find(params[:id])
    @persona = Persona.find(@cargo.persona_id)
  end

  def guardar_edicion
    @tipo_documento = params["tipo_documento"]
    @sexo = params["sexo"]
    @dni = params["dni"]
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(nro_documento: @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(tipo_documento_id: @tipo_documento, nro_documento: @dni, sexo_id: @sexo, nombres: @nombres, apellidos: @apellidos, :apeynom => "#{@apellidos} #{@nombres}", cuil: @cuil, 
                                fecha_nacimiento: @fecha_nacimiento)
    else
      @persona.assign_attributes({tipo_documento_id: @tipo_documento, nro_documento: @dni, nombres: @nombres, apellidos: @apellidos, :apeynom => "#{@apellidos} #{@nombres}", cuil: @cuil,
                                  fecha_nacimiento: @fecha_nacimiento})
    end
    @cargo = Cargo.find(params[:id])
    @cargo.assign_attributes({ persona_id: @persona.id, cargo: params[:cargo][:cargo], secuencia: params[:cargo][:secuencia], fecha_alta: params[:cargo][:fecha_alta], fecha_baja: params[:cargo][:fecha_baja],
                              situacion_revista: params[:cargo][:situacion_revista], anio: params[:cargo][:anio], division: params[:cargo][:division],
                              turno: params[:cargo][:turno], grupo_id: params[:cargo][:grupo_id], observaciones: params[:cargo][:observaciones]})
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
    elsif @cargo.estado_anterior == "Chequeado_Modificacion"
      @estado = Estado.where(descripcion: "Chequeado_Modificacion").first
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
    @cargo.update(updated_at: Date.today)
    @estado = Estado.where(descripcion: "Chequeado").first
    CargoEstado.create( cargo_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to cargos_path, notice: 'Alta chequeada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def dar_baja
    if @cargo.estado_actual == "Vacio" || @cargo.estado_actual == "Impreso" || @cargo.estado_actual == "Cobrado" || @cargo.estado_actual == "Cancelado_Baja"
      if @cargo.update(:fecha_baja => params[:cargo][:fecha_baja])
        @estado = Estado.where(:descripcion => "Notificado_Baja").first
        if @cargo.fecha_baja != nil
          CargoEstado.create(estado_id: @estado.id, cargo_id: @cargo.id, user_id: current_user.id)
        end
        respond_to do |format|
          format.json { render json: {status: 'ok'}}
        end
      else
        respond_to do |format|
          format.json { render json: @cargo.errors.full_messages[0], status: :unprocessable_entity} # 204 No Content
        end
      end
    else 
      respond_to do |format|
        format.json { render json: "No se puede dar de baja hasta terminar el proceso de carga anterior", status: :unprocessable_entity} # 204 No Content
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
      cargo = Cargo.find(params["id"])
      estado = Estado.where(descripcion: "Impreso").first
      lote_impresion = LoteImpresion.where(fecha_impresion: nil, tipo_id: 2).last
      if lote_impresion == nil
        lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil, tipo_id: 2)
      end
      if cargo.estado_actual == "Chequeado"
        if cargo.update!(alta_lote_impresion_id: lote_impresion.id)
          CargoEstado.create( cargo_id: cargo.id, estado_id: estado.id, user_id: current_user.id)
          format.json { head :no_content } # 204 No Content
        else
          format.json { head :no_content } # 204 No Content
        end
      elsif cargo.estado_actual == "Chequeado_Baja"
        if cargo.update!(baja_lote_impresion_id: lote_impresion.id)
          CargoEstado.create( cargo_id: cargo.id, estado_id: estado.id, user_id: current_user.id)
          format.json { head :no_content } # 204 No Content
        else
          format.json { head :no_content } # 204 No Content
        end
      end
    end
  end

  def cancelar_baja
    if Cargo.find(params["id"]).estado_actual == "Notificado_Baja"
      if @cargo.update(:fecha_baja => nil, estado: 'ALT')
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
    @bajas = cargo_bajas_efectivas(@mindate, @maxdate)
    respond_to do |format|
      format.json { render json: CargosBajasEfectivasDatatable.new(view_context, { query: @bajas, rol: @rol }) }
      format.pdf do
        render :pdf => 'bajas_notificadas',
        :template => 'cargos/reporte_cargos_baja.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
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
    @cargos_notificados = cargos_notificados_permitidos(@mindate, @maxdate)
    respond_to do |format|
      format.json { render json: CargosNotificadosDatatable.new(view_context, { query: @cargos_notificados, rol: @rol }) }
      format.pdf do
        render :pdf => 'cargos_notificados',
        :template => 'cargos/reporte_cargos_notificados.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
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
    @novedades_en_cola_impresion =  Cargo.where(id: -1).includes(:persona, :establecimiento)
     if @lote != nil then
      if @lote.fecha_impresion == nil
        @novedades_en_cola_impresion = Cargo.where("alta_lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s).includes(:persona, :establecimiento)
      end
    end
    respond_to do |format|
      format.html
      format.json { render json: CargosNovedadesDatatable.new(view_context, { query: @novedades_en_cola_impresion }) }
    end
  end


def editar_campos
    @altas_bajas_hora = Cargo.where(id: params["id"])
    if @altas_bajas_hora.count > 0
      if params["post"]["division"] != nil
        @altas_bajas_hora.first.update(division: params["post"]["division"])
      end 
      if params["post"]["anio"] != nil
        @altas_bajas_hora.first.update(anio: params["post"]["anio"])
      end
      if params["post"]["turno"] != nil
        @altas_bajas_hora.first.update(turno: params["post"]["turno"])
      end 
      if params["post"]["materia_id"] != nil
        @altas_bajas_hora.first.update(materia_id: params["post"]["materia_id"])
      end
    else
      if params["post"]["division"] != nil
        Cargo.create(division: params["post"]["division"], altas_bajas_hora_id: params["id"])
      end 
      if params["post"]["anio"] != nil
        Cargo.create(anio: params["post"]["anio"], altas_bajas_hora_id: params["id"])
      end
      if params["post"]["turno"] != nil
        Cargo.create(turno: params["post"]["turno"], altas_bajas_hora_id: params["id"])
      end 
      if params["post"]["materia_id"] != nil
        Cargo.create(materia_id: params["post"]["materia_id"], altas_bajas_hora_id: params["id"])
      end
    end
   respond_to do |format|
      format.html
      format.json { render json: CargosDatatable.new(view_context, { query: cargos_modificacion }) }
    end
end




  def modificacion
    @cargos= Cargo.where(:establecimiento_id => session[:establecimiento]).first
    respond_to do |format|
      format.html
      format.json { render json: CargosDatatable.new(view_context, { query: cargos_modificacion }) }
    end
  end



  def mostrar_edicion

    @persona_id=Cargo.where(:id => params[:id]).first.persona_id
    @persona = Persona.where(:id => @persona_id).first
    render json: @persona
  end


  def buscar_cuil
    @persona_id=Cargo.where(:id => params[:id]).first.persona_id
    @persona = Persona.where(:id => @persona_id).first.nro_documento
    
    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
    @cuil= client.query("select cuit from agentes_dni_cuit a where '"+ @persona.to_s + "' = a.nume_docu")

   respond_to do |format|
        format.json { render json: @cuil}
      end     
  end

   def mostrar_edicion2
    @cargos=Cargo.where(:id => params[:id]).first
    @registro=Cargo.where(:id => params[:id]).first
 

    respond_to do |format|
      format.json { render json: @cargos }
    end
  end


 def guardar_edicion2   

    @persona = Persona.where(:nro_documento => params[:dni]).first
    @cargos = Cargo.where(:id => params[:edi]).first
    @cargos.persona_id = Persona.where(:nro_documento => params[:dni]).first.id
    #@persona.tipo_documento_id = TipoDocumento.where(:id => params[:tipo_documento]).first.id
    @persona.fecha_nacimiento = params[:fecha_nacimiento]
    @persona.cuil = params[:cuil] 
    @persona.sexo_id = Sexo.where(:id => params[:sexo]).first.id
    @cargos.anio = params[:curso]
    @cargos.division = params[:division]
    @cargos.resolucion = params[:resolucion]
    @cargos.disposicion = params[:disposicion]
    @cargos.turno = params[:turno]


    #@cargos.cargo = Funcion.where(:id => params[:cargo]).first.categoria
    @cargos.situacion_revista = params[:cargo][:situacion_revista]
    if params[:materium_id] != "" then 
      @cargos.materium_id = params[:materium_id]
    end
    @cargos.grupo_id = params[:grupo_id]
    @cargos.observaciones = params[:observaciones]

  if @cargos.estado == "REU" then
          
          if params[:estado] == "ALT"  then
            @cargos.estado = params[:estado]
          end
  end 




    if @cargos.estado == "LIC" then
        if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
          @cargos.estado = params[:estado]
        end
        if params[:estado] == "ALT" then
            flash[:error] = 'No debe pasar del estado LIC a ALT'
            @cargos.estado = "LIC"
        end
    end 

    if @cargos.estado == "ALT" then
        if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
            flash[:error] = 'No debe pasar del estado ALT a LIC'
            @cargos.estado = "ALT"
        end
    end
    
    if @cargos.estado == "LIC P/BAJ" then
      if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
         
          @cargos.estado = params[:estado]
        end
      if params[:estado] == "ALT" then
            flash[:error] = 'No debe pasar del estado LIC a ALT'
            @cargos.estado = "LIC P/BAJ"
      end
    end



   respond_to do |format|
        if @persona.save then       
          if @cargos.save then
            format.html { redirect_to cargos_modificacion_path, notice: 'Registro actualizado correctamente' }
            format.json { render action: 'modificacion', status: :created, location: @cargos }
          else
            format.html { render action: 'modificacion' }
            #format.html { redirect_to cargos_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
            @cargos.errors.full_messages.each do |msg|
              flash[:error] = msg
            end
            format.json do
              render json: flash
            end
          end        
        else

          format.html { render action: 'modificacion' }
          #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
          @persona.errors.full_messages.each do |msg|
            flash[:error] = msg
          end
          format.json do
            render json: flash
          end
        end
    end    
    
  
  end



  #---------------------------------------------------------------------------------------------------------------------------------------------------

  private
    def set_cargo
      @cargo = Cargo.find(params[:id])
    end

    def cargo_params
      params.require(:cargo).permit(:establecimiento_id, :persona_id, :cargo, :secuencia, :situacion_revista, :turno, :anio, :curso, :division, :fecha_alta, :fecha_baja, :persona_reemplazada_id, :observatorio, :alta_lote_impresion_id, :baja_lote_impresion,:empresa_id, :lugar_pago_id, :con_movilidad, :grupo_id, :ina_injustificadas, :licencia_desde, :licencia_hasta, :cantidad_dias_licencia, :motivo_baja, :disposicion, :resolucion, :cargo_especial_id)
    end
end


