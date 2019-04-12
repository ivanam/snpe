class AltasBajasHorasController < ApplicationController
  before_action :set_altas_bajas_hora, only: [:show, :edit, :update, :destroy, :dar_baja]
  load_and_authorize_resource

  def index
    @motivo_baja = select_motivo_baja
    @planes_permitidos = select_planes_permitidos    

    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    if @altas_bajas_hora == nil
      @altas_bajas_hora = AltasBajasHora.new
    end
    if @persona == nil
      @persona = Persona.new
    end
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas(@mindate, @maxdate) }) }
    end
  end

  def index_novedades
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    respond_to do |format|
      format.html
      format.json { render json: HorasNovedadesDatatable.new(view_context, { query: horas_novedades(@mindate, @maxdate), :tipo_tabla => "novedades" }) }
    end
  end

  def index_notificadas
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    @altas_notificadas = altas_bajas_horas_permitidas_altas_notificadas(@mindate, @maxdate)
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraNotificadaDatatable.new(view_context, { query: @altas_notificadas, rol: @rol }) }
      format.pdf do
        render :pdf => 'altas_notificadas',
        :template => 'altas_bajas_horas/reporte_altas_notificadas.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
    end
  end

  def index_cola_impresion
    @lote = LoteImpresion.all.where(tipo_id: 1).last
    @novedades_en_cola_impresion = AltasBajasHora.where(id: -1).includes(:persona, :materium)
    if @lote != nil then
      if  @lote.fecha_impresion == nil
        #@novedades_en_cola_impresion = AltasBajasHora.where(lote_impresion_id: @lote.id OR baja_lote_impresion_id: @lote.id)
        if current_user.role? :delegacion 
        @novedades_en_cola_impresion = AltasBajasHora.where("baja_lote_impresion_id = " + @lote.id.to_s).includes(:persona, :materium)
        else
        @novedades_en_cola_impresion = AltasBajasHora.where("lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s).includes(:persona, :materium).where(:establecimiento_id => session[:establecimiento])
        end      
      end
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
    @novedades_ids = []
    @lote = LoteImpresion.all.where(tipo_id: 1).last
    if @lote.fecha_impresion != nil
      @mindate, @maxdate = Util.max_min_periodo(params["rango"])
      horas_novedades(@mindate, @maxdate).where(lote_impresion_id: nil).each do |h|
        if h.estado_actual == "Impreso"
          @novedades_ids << h.id
        end
      end
      
      @novedades_en_cola_impresion = AltasBajasHora.where(id: @novedades_ids)
      respond_to do |format|
        format.html { redirect_to horas_index_novedades_path}
        format.json { head :no_content } # 204 No Content
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
    AltasBajasHoraEstado.create( alta_baja_hora_id: @hora.id, estado_id: @estado.id, user_id: current_user.id)
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
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    @bajas = altas_bajas_horas_efectivas_bajas(@mindate.to_date, @maxdate.to_date)
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaEfectivaDatatable.new(view_context, { query: @bajas , rol: @rol }) }
      format.pdf do
        render :pdf => 'bajas_notificadas',
        :template => 'altas_bajas_horas/reporte_horas_baja.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
    end
  end

  def index_bajas_notificadas_chequear
    @mindate, @maxdate = Util.max_min_periodo(params["rango"])
    @rol = Role.where(:id => UserRole.where(:user_id => current_user.id).first.role_id).first.description
    @bajas = altas_bajas_horas_notificadas(@mindate.to_date, @maxdate.to_date)
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaNotificadasDatatable.new(view_context, { query: @bajas , rol: @rol }) }
      format.pdf do
        render :pdf => 'bajas_notificadas',
        :template => 'altas_bajas_horas/reporte_horas_baja.html.erb',
        :layout => 'pdf.html.erb',
        :orientation => 'Landscape',# default Portrait
        :page_size => 'Legal', # default A4
        :show_as_html => params[:debug].present?
      end
    end
  end





  def show

    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    @licencias = Licencium.where(:altas_bajas_hora_id => params[:id])
    @anuales2018 = @licencias.where("articulo_id in (241, 289,365,366) and anio_lic = 2018")
    @anuales2017 = @licencias.where("articulo_id in (241, 289,365,366) and anio_lic = 2017")
    @anuales2016 = @licencias.where("articulo_id in (241, 289,365,366) and anio_lic = 2016")
    @anuales2015 = @licencias.where("articulo_id in (241, 289,365,366) and anio_lic = 2015")
    @anuales = @licencias.where("articulo_id in (241, 289,365,366) and (anio_lic = 0 or anio_lic != null)")


    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        #:template => 'entradas/show.html.erb',
        :template => 'altas_bajas_horas/historial_pdf.html.erb',
        #:layout => 'application.html.erb',
        :layout => 'pdf.html.erb',
        :show_as_html => params[:debug].present?
      end
    end
  end

  def new
    @altas_bajas_hora = AltasBajasHora.new
    respond_with(@altas_bajas_hora)
  end

  def edit
  end

  def create
    @planes_permitidos = select_planes_permitidos
    @tipo_documento = params["tipo_documento"]
    @sexo = params["sexo"]

    #@tipoHora = params["tipo_hora"]
    @dni = params["dni"]
    @apeynom = params["apeynom"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(:nro_documento => @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])    
    
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(:tipo_documento_id => @tipo_documento, :sexo_id => @sexo, :nro_documento => @dni, :apeynom => @apeynom, :cuil => @cuil, :fecha_nacimiento => @fecha_nacimiento )
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.sexo_id = @sexo
      @persona.nro_documento = @dni
      @persona.apeynom = @apeynom
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento      
    end
    @altas_bajas_hora = AltasBajasHora.new(altas_bajas_hora_params)
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.esprovisorio = params[:altas_bajas_hora][:esprovisorio]
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.establecimiento_id = @establecimiento.id
    @altas_bajas_hora.programatica = params[:altas_bajas_hora][:programatica]
    @estado = Estado.where(:descripcion => "Ingresado").first
    @altas_bajas_hora.oblig = params[:altas_bajas_hora][:oblig]
    @altas_bajas_hora.observaciones = params[:altas_bajas_hora][:observaciones]
    @altas_bajas_hora.resolucion = params[:altas_bajas_hora][:resolucion]
    @altas_bajas_hora.decreto = params[:altas_bajas_hora][:decreto]
    #@altas_bajas_hora.tipo_hora = params[:altas_bajas_hora][:tipo_hora]

    #Estado, necesario para Ministerio de economia
    @altas_bajas_hora.estado = "ALT"

    @empresa = Empresa.where(:nombre => "HS").first
    @altas_bajas_hora.empresa_id = @empresa.id
    
    @altas_bajas_hora.materium_id = params[:altas_bajas_hora][:materium_id]    
    @materia = Materium.find(params[:altas_bajas_hora][:materium_id])    
    @altas_bajas_hora.codificacion = @materia.codigo

    respond_to do |format|
      if @persona.save then      
          if @altas_bajas_hora.save then
            AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @altas_bajas_hora.id, user_id: current_user.id)
            format.html { redirect_to altas_bajas_horas_path, notice: 'Alta realizada correctamente' }
            format.json { render action: 'show', status: :created, location: @cargo }
          else
            @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id , @altas_bajas_hora.anio)      
            format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }
            format.html { render action: 'index' }
          end        
      else
          @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id , @altas_bajas_hora.anio)      
          format.json { render json: @persona.errors, status: :unprocessable_entity }
          format.html { render action: 'index' }
      end
    end
  end

  def cargo_por_materia
    @altas_escuela = AltasBajasHora.where(:establecimiento_id => session[:establecimiento], division: params[:division], anio: params[:anio], plan_id: params[:plan_id], materium_id: params[:materium_id])
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraMateriaDatatable.new(view_context, { query: @altas_escuela }) }
    end
  end

  def editar_alta
    @planes_permitidos = select_planes_permitidos
    @altas_bajas_hora = AltasBajasHora.find(params[:id])    
    @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id, @altas_bajas_hora.anio)    
    @persona = Persona.find(@altas_bajas_hora.persona_id)
  end


  def modificar
    @planes_permitidos = select_planes_permitidos
    @altas_bajas_hora = AltasBajasHora.find(params[:id])    
    @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id, @altas_bajas_hora.anio)    
    @persona = Persona.find(@altas_bajas_hora.persona_id)
  end


  def modificacion
      @planes_permitidos = select_planes_permitidos
      @altas_bajas_horas= AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).first
         
      respond_to do |format|
        format.html
        format.json { render json: AltasBajasHora2Datatable.new(view_context, { query: altas_bajas_horas_modificacion }) }
      end
  end




  def mostrar_edicion

    @persona_id=AltasBajasHora.where(:id => params[:id]).first.persona_id
    @persona = Persona.where(:id => @persona_id).first
    render json: @persona
  end


  def buscar_cuil
    @persona_id=AltasBajasHora.where(:id => params[:id]).first.persona_id
    @persona = Persona.where(:id => @persona_id).first.nro_documento
    
    client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")
    @cuil= client.query("select cuit from agentes_dni_cuit a where '"+ @persona.to_s + "' = a.nume_docu")

   respond_to do |format|
        format.json { render json: @cuil}
      end     
  end

   def mostrar_edicion2
    @altas_bajas_horas=AltasBajasHora.where(:id => params[:id]).first
    @registro=AltasBajasHora.where(:id => params[:id]).first
    @materias_permitidas = select_materias_permitidas(@registro.plan_id, @registro.anio)

    respond_to do |format|
      format.json { render json: @altas_bajas_horas }
    end
  end



 def guardar_edicion    
    @tipo_documento = params["tipo_documento"]
    @dni = params["dni"]
    @apeynom = params["apeynom"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @sexo = params["sexo"]
    @persona = Persona.where(:nro_documento => @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(:tipo_documento_id => @tipo_documento, :nro_documento => @dni, :nombres => @nombres, :apellidos => @apellidos, :apeynom => "#{@apellidos} #{@nombres}", :cuil => @cuil, :fecha_nacimiento => @fecha_nacimiento )
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.sexo_id = @sexo
      @persona.nro_documento = @dni
      @persona.apeynom = @apeynom
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento    
    end
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.secuencia = params[:altas_bajas_hora][:secuencia]
    @altas_bajas_hora.fecha_alta = params[:altas_bajas_hora][:fecha_alta]
    @altas_bajas_hora.fecha_baja = params[:altas_bajas_hora][:fecha_baja]
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.ciclo_carrera = params[:altas_bajas_hora][:ciclo_carrera]
    @altas_bajas_hora.anio = params[:altas_bajas_hora][:anio]
    @altas_bajas_hora.division = params[:altas_bajas_hora][:division]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.plan_id = params[:altas_bajas_hora][:plan_id]
    @altas_bajas_hora.horas = params[:altas_bajas_hora][:horas]
    @altas_bajas_hora.materium_id = params[:altas_bajas_hora][:materium_id]    
    @materia = Materium.find(params[:altas_bajas_hora][:materium_id])
    @altas_bajas_hora.codificacion = @materia.codigo
    @altas_bajas_hora.lugar_pago_id = params[:altas_bajas_hora][:lugar_pago_id]
    @altas_bajas_hora.grupo_id = params[:altas_bajas_hora][:grupo_id]
    @altas_bajas_hora.resolucion = params[:altas_bajas_hora][:resolucion]
    @altas_bajas_hora.decreto = params[:altas_bajas_hora][:decreto]
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
          @planes_permitidos = select_planes_permitidos
          @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id, @altas_bajas_hora.anio)
          format.html { render action: 'editar_alta' }
          #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
          format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }
          #respond_with(@altas_bajas_hora, :location => altas_bajas_horas_path)  
        end        
      else
        @planes_permitidos = select_planes_permitidos
        @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id, @altas_bajas_hora.anio)
        format.html { render action: 'editar_alta' }
        #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
        format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end

  end

  def guardar_edicion2   
    
    @persona = Persona.where(:nro_documento => params[:dni]).first
    @altas_bajas_horas = AltasBajasHora.where(:id => params[:edi]).first
    @altas_bajas_horas.persona_id = Persona.where(:nro_documento => params[:dni]).first.id
    #@persona.tipo_documento_id = TipoDocumento.where(:id => params[:tipo_documento]).first.id
    @persona.fecha_nacimiento = params[:fecha_nacimiento]
    @persona.cuil = params[:cuil] 
    @persona.sexo_id = Sexo.where(:id => params[:sexo]).first.id
    @altas_bajas_horas.turno = params[:turno]
    @altas_bajas_horas.anio = params[:anio]
    @altas_bajas_horas.division = params[:division]
    @altas_bajas_horas.materium_id = params[:materium_id]
    @altas_bajas_horas.esprovisorio = params[:esprovisorio]
    if Materium.where(:id => params[:materium_id]).first != nil
      @altas_bajas_horas.codificacion = Materium.where(:id => params[:materium_id]).first.codigo
    end
    @altas_bajas_horas.grupo_id = params[:grupo_id]
    @altas_bajas_horas.observaciones = params[:observaciones]
    @altas_bajas_horas.plan_id = params[:plan_id]
    if params[:plan_id] != nil and params[:plan_id] != ""
      @altas_bajas_horas.ciclo_carrera = Plan.where(:id => params[:plan_id]).first.codigo
    end

    @altas_bajas_horas.resolucion = params[:resolucion]
    @altas_bajas_horas.decreto = params[:decreto]
    @altas_bajas_horas.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    if @altas_bajas_horas.estado == "LIC" then
        if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
          @altas_bajas_horas.estado = params[:estado]
        end
        if params[:estado] == "ALT" then
            flash[:error] = 'No debe pasar del estado LIC a ALT'
            @altas_bajas_horas.estado = "LIC"
        end
    end 

    if @altas_bajas_horas.estado == "ALT" then
        if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
            flash[:error] = 'No debe pasar del estado ALT a LIC'
            @altas_bajas_horas.estado = "ALT"
        end
    end
    
    if @altas_bajas_horas.estado == "LIC P/BAJ" then
      if params[:estado] == "LIC" || params[:estado] == "LIC P/BAJ" then
         
          @altas_bajas_horas.estado = params[:estado]
        end
      if params[:estado] == "ALT" then
            flash[:error] = 'No debe pasar del estado LIC a ALT'
            @altas_bajas_horas.estado = "LIC P/BAJ"
      end
    end

    if @altas_bajas_horas.estado != "LIC P/BAJ" then

        if  params[:plan_id] != nil and params[:plan_id] != "" then

          @altas_bajas_horas.plan_id = params[:plan_id]
          @altas_bajas_horas.ciclo_carrera = Plan.where(:id => params[:plan_id]).first.codigo
            respond_to do |format|
              if @persona.save then       
                if @altas_bajas_horas.save then
                  format.html { redirect_to altas_bajas_horas_modificacion_path, notice: 'Registro actualizado correctamente' }
                  format.json { render action: 'modificacion', status: :created, location: @altas_bajas_horas }
                else
                  @planes_permitidos = select_planes_permitidos
                  format.html { render action: 'modificacion' }
                  @altas_bajas_horas.errors.full_messages.each do |msg|
                    flash[:error] = msg
                  end
                  format.json do
                    render json: flash
                  end
                end        
              else
                @planes_permitidos = select_planes_permitidos
                format.html { render action: 'modificacion' }
                #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
                format.json { render json: @persona.errors, status: :unprocessable_entity }
              end
          end    
        else
          flash[:error]= "Debe completar el plan"
          respond_to do |format|
            @planes_permitidos = select_planes_permitidos
            format.html { render action: 'modificacion' }
            format.json { render json: @altas_bajas_horas.errors, status: :unprocessable_entity }
          end
        end

    else
      respond_to do |format|
        
      if @persona.save then       
        if @altas_bajas_horas.save then
          format.html { redirect_to altas_bajas_horas_modificacion_path, notice: 'Registro actualizado correctamente' }
          format.json { render action: 'modificacion', status: :created, location: @altas_bajas_horas }
        else
          @planes_permitidos = select_planes_permitidos
          format.html { render action: 'modificacion' }
          @altas_bajas_horas.errors.full_messages.each do |msg|
            flash[:error] = msg
          end
          format.json do
            render json: flash
          end
        end        
      else
        @planes_permitidos = select_planes_permitidos
        format.html { render action: 'modificacion' }
        #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
      end
    end    

      
    end
  
  end
  
  def update
    @altas_bajas_hora.update(altas_bajas_hora_params_update)
    respond_with(@altas_bajas_hora)
  end

  def guardar_edicion3
          @altas_bajas_hora = AltasBajasHora.find(params[:id_lic]) 
          if @altas_bajas_hora.update(:estado => "LIC P/BAJ")
            respond_to do |format|
            format.html { redirect_to altas_bajas_horas_modificacion_path, notice: 'Registro actualizado correctamente' }
            format.json { render action: 'modificacion', location: @altas_bajas_horas }
            end
           else
            respond_to do |format|
            format.html { render action: 'modificacion' }
            format.json { render json: @altas_bajas_horas.errors, status: :unprocessable_entity }
            end
          end
  end

  def destroy
    @altas_bajas_hora = AltasBajasHora.find(params[:id])  
    @altas_bajas_hora.estados.destroy_all
    @altas_bajas_hora.destroy
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_url, notice: 'Se ha eliminado la carga' }
      format.json { head :no_content }
    end
  end
  
  def dar_baja
    if @altas_bajas_hora.estado_actual == "Vacio" || @altas_bajas_hora.estado_actual == "Impreso" || @altas_bajas_hora.estado_actual == "Cobrado" || @altas_bajas_hora.estado_actual == "Cancelado_Baja"
       if params[:input_fecha_baja] != nil && params[:input_fecha_baja] != ""
         if params[:motivo_baja] != nil && params[:motivo_baja] != ""
            if @altas_bajas_hora.update(:fecha_baja => params[:input_fecha_baja], :motivo_baja => params[:motivo_baja])
              @estado = Estado.where(:descripcion => "Notificado_Baja").first
              AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @altas_bajas_hora.id, user_id: current_user.id)      
              respond_to do |format|
              format.json { render json: {status: 'ok'}}
              end
            else
              respond_to do |format|
              format.json { render json: {status: 'error', msj: @altas_bajas_hora.errors.full_messages[0]} }
              end
            end  
         else
           respond_to do |format|
           format.json { render json: {status: 'error', msj: "Debe completar el motivo de la baja"} }
           flash[:notice] = "motivo."
           end
         end
       else
        respond_to do |format|
        format.json { render json: {status: 'error', msj: "Debe completar la fecha de baja"} }
        format.html { redirect_to altas_bajas_horas_index_bajas_path, notice: 'fecha' }
        end
      end
    else
      respond_to do |format|
        format.json { render json: "No se puede dar de baja hasta terminar el proceso de carga anterior", status: :unprocessable_entity} # 204 No Content
        format.html { redirect_to altas_bajas_horas_index_bajas_path, notice: 'proceso' }
      end
    end
  end

  def cancelar_baja
    if AltasBajasHora.find(params["id"]).estado_actual == "Notificado_Baja"
      if @altas_bajas_hora.update(:fecha_baja => nil, estado: 'ALT', :motivo_baja => nil)
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
    @altas_bajas_hora.update(updated_at: Date.today)
    @estado = Estado.where(descripcion: "Chequeado").first
    AltasBajasHoraEstado.create( alta_baja_hora_id: params["id"], estado_id: @estado.id, user_id: current_user.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta chequeada' }
      
    end
  end

  def imprimir
    hora = AltasBajasHora.find(params["id"])
    estado = Estado.where(descripcion: "Impreso").first
    lote_impresion = LoteImpresion.where(fecha_impresion: nil, tipo_id: 1).last
    if lote_impresion == nil
      lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil, tipo_id: 1)
    end
    if hora.estado_actual == "Chequeado"
      if hora.update(lote_impresion_id: lote_impresion.id)
        AltasBajasHoraEstado.create( alta_baja_hora_id: hora.id, estado_id: estado.id, user_id: current_user.id)
        render json: "".to_json
      else
        msj = hora.errors.full_messages[0]
        render json: msj.to_json
      end
    elsif hora.estado_actual == "Chequeado_Baja"
      if hora.update(baja_lote_impresion_id: lote_impresion.id)
        AltasBajasHoraEstado.create( alta_baja_hora_id: hora.id, estado_id: estado.id, user_id: current_user.id)
        render json: "".to_json
      else
        msj = hora.errors.full_messages[0]
        render json: msj.to_json
      end
    end
  end

  def buscar_alta
    if AltasBajasHora.where(:id => params[:id_alta]).count > 0 then
      @alta = AltasBajasHora.where(:id => params[:id_alta]).first
      render json: @alta      
    end
  end



def editar_campos
    @altas_bajas_hora = AltasBajasHora.where(id: params["id"])
    if @altas_bajas_hora.count > 0
      if params["put"]["division"] != nil
        @altas_bajas_hora.first.update(division: params["put"]["division"])
      end 
      if params["put"]["anio"] != nil
        @altas_bajas_hora.first.update(anio: params["put"]["anio"])
      end
      if params["put"]["turno"] != nil
        @altas_bajas_hora.first.update(turno: params["put"]["turno"])
      end 
      if params["put"]["codificacion"] != nil
        @altas_bajas_hora.first.update(codificacion: params["put"]["codificacion"])
      end
    else
      if params["put"]["division"] != nil
        AltasBajasHora.create(division: params["put"]["division"], altas_bajas_hora_id: params["id"])
      end 
      if params["put"]["anio"] != nil
        AltasBajasHora.create(anio: params["put"]["anio"], altas_bajas_hora_id: params["id"])
      end
      if params["put"]["turno"] != nil
        AltasBajasHora.create(turno: params["put"]["turno"], altas_bajas_hora_id: params["id"])
      end 
      if params["put"]["codificacion"] != nil
        AltasBajasHora.create(codificacion: params["put"]["codificacion"], altas_bajas_hora_id: params["id"])
      end


    end

   respond_to do |format|
      if @altas_bajas_hora.first.errors.messages.length > 0
        format.html
        format.json { render json: AltasBajasHora2Datatable.new(view_context, { query: altas_bajas_horas_modificacion }), status: :error }
      else
        format.html
        format.json { render json: AltasBajasHora2Datatable.new(view_context, { query: altas_bajas_horas_modificacion }) }
      end
    end
end


  private
    def set_altas_bajas_hora
      if params[:id] != nil
        @altas_bajas_hora = AltasBajasHora.find(params[:id])
       else
        @altas_bajas_hora = AltasBajasHora.find(params[:id_horas])
      end  
    end

    def altas_bajas_hora_params
      params.require(:altas_bajas_hora).permit(:establecimiento_id, :mes_periodo, :anio_periodo, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :horas, :ciclo_carrera, :anio, :division, :turno, :codificacion, :resolucion, :decreto, :oblig, :observaciones, :empresa_id, :lugar_pago_id, :estado, :con_movilidad, :plan_id, :materium_id, :grupo_id, :esprovisorio)
    end

    def altas_bajas_hora_params_update
      params.require(:altas_bajas_hora).permit(:establecimiento_id, :mes_periodo, :anio_periodo, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :ciclo_carrera, :anio, :division, :turno, :codificacion, :resolucion, :decreto, :oblig, :observaciones, :empresa_id, :lugar_pago_id, :estado, :con_movilidad, :plan_id, :materium_id, :grupo_id, :esprovisorio)
    end


end
