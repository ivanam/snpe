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
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraNotificadaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas_notificadas(@mindate, @maxdate), rol: @rol }) }
    end
  end

  def index_cola_impresion
    @lote = LoteImpresion.all.where(tipo_id: 1).last
    @novedades_en_cola_impresion = AltasBajasHora.where(id: -1).includes(:persona, :materium)
    if @lote != nil then
      if  @lote.fecha_impresion == nil
        #debugger
        #@novedades_en_cola_impresion = AltasBajasHora.where(lote_impresion_id: @lote.id OR baja_lote_impresion_id: @lote.id)
        @novedades_en_cola_impresion = AltasBajasHora.where("lote_impresion_id =" + @lote.id.to_s + " OR baja_lote_impresion_id = " + @lote.id.to_s).includes(:persona, :materium)
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
    @lote = LoteImpresion.all.where(tipo_id: 1).last
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
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaEfectivaDatatable.new(view_context, { query: altas_bajas_horas_efectivas_bajas(@mindate.to_date, @maxdate.to_date), rol: @rol }) }
    end
  end

  def show
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
  end

  def show
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'file_name',
        #:template => 'entradas/show.html.erb',
        :template => 'altas_bajas_horas/pdf.html.erb',
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
    @dni = params["dni"]
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
    @cuil = params["cuil"]
    @fecha_nacimiento = params["fecha_nacimiento"]
    @persona = Persona.where(:nro_documento => @dni).first
    @establecimiento = Establecimiento.find(session[:establecimiento])    
    
    #si la persona no existe la creo
    if @persona == nil then
      @persona = Persona.create(:tipo_documento_id => @tipo_documento, :sexo_id => @sexo, :nro_documento => @dni, :nombres => @nombres, :apellidos => @apellidos, :apeynom => "#{@apellidos} #{@nombres}", :cuil => @cuil, :fecha_nacimiento => @fecha_nacimiento )
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.sexo_id = @sexo
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.apeynom = "#{@apellidos} #{@nombres}"
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento      
    end
    @altas_bajas_hora = AltasBajasHora.new(altas_bajas_hora_params)
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.establecimiento_id = @establecimiento.id
    @altas_bajas_hora.programatica = params[:altas_bajas_hora][:programatica]
    @estado = Estado.where(:descripcion => "Ingresado").first

    #Estado, necesario para Minsiterio de economia
    @altas_bajas_hora.estado = "ALT"

    @empresa = Empresa.where(:nombre => "HS").first
    @altas_bajas_hora.empresa_id = @empresa.id
    
    @altas_bajas_hora.materium_id = params[:altas_bajas_hora][:materium_id]    
    @materia = Materium.find(params[:altas_bajas_hora][:materium_id])    
    @altas_bajas_hora.codificacion = @materia.codigo


    @altas_escuela = AltasBajasHora.where(:establecimiento_id => session[:establecimiento], division: params[:altas_bajas_hora][:division], turno: params[:altas_bajas_hora][:turno], anio: params[:altas_bajas_hora][:anio], plan_id: params[:altas_bajas_hora][:plan_id], materium_id: params[:altas_bajas_hora][:materium_id])
 
    if @altas_escuela == [] then
      @caso = 1 #Caso ok 
    elsif params[:altas_bajas_hora][:situacion_revista] == "1-1" then #Se quiere crear un titular
      if @altas_escuela.where(situacion_revista: "1-1").first then 
        @caso = 2 #1- hay un titular y se quiere dar de alta un titular
      else
        @caso = 3 #2- hay un (interino,reemplazante, supl. larga, supl. corta, etc.) y se quiere de alta un titular
      end
    elsif params[:altas_bajas_hora][:situacion_revista] =="1-2" then #Se quiere crear un interino
      if @altas_escuela.where(situacion_revista: "1-2").first then
        @caso = 4 #3- hay un interino y se quiere dar de alta un interino
      else
        @caso = 5 #4- hay un (interino,reemplazante, supl. larga, supl. corta, etc.) y se quiere dar de alta interino
      end
    elsif params[:altas_bajas_hora][:situacion_revista] == "1-3" then #Se quiere crear un reemplazante
      reemplazante_de = con_licencia_reemplazante(@altas_escuela) 
      if  reemplazante_de != [] then  
          @caso = 6 #2- tiene licencia para reemplazar
      else
          @caso = 7 #3- no tiene licencia el suplente
      end
    elsif params[:altas_bajas_hora][:situacion_revista] == "2-3" || params[:altas_bajas_hora][:situacion_revista] == "2-4" then #Se quiere crear suplente de larga duracion o corta duracion
      suplente_de = con_licencia_suplente(@altas_escuela)
      if  suplente_de != [] then
          @caso = 8 #4- tiene licencia para suplente 
      else
          @caso = 9 #5- no tiene licencia el suplente
      end
    else
      @caso=0
    end

    respond_to do |format|

      #|| (params[:altas_bajas_hora][:situacion_revista] == "1-003" && @altas_escuela != [] && con_licencia(@altas_escuela))  then

      if [1,6,8].include? @caso then
        if @persona.save then           
            if @altas_bajas_hora.save then            
              AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: @altas_bajas_hora.id, user_id: current_user.id)
              if @caso != 1 then
                if @caso == 6 then
                  @suplente=Suplente.create(tipo_suplente: "Reemplazante",altas_bajas_hora_id: @altas_bajas_hora.id, estado: "Activo")
                elsif @caso == 8 then
                  @suplente =Suplente.create(tipo_suplente: "Suplente",altas_bajas_hora_id: @altas_bajas_hora.id, estado: "Activo")
                end                
                @altas_escuela.first.suplente_id = @suplente.id #ver q cada metodo devuelva si tiene licencia y el ultimo alta para poner este valor y enlazar
                @altas_escuela.first.save
              end  
              format.html { redirect_to altas_bajas_horas_path, notice: 'Alta realizada correctamente' }
              format.json { render action: 'show', status: :created, location: @altas_bajas_hora }
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
      else
        if @altas_bajas_hora.valid?
          if @caso == 2 then
            flash[:error] = "Se quiere dar de alta un titular y ya existe"          
          elsif @caso == 3 then
            flash[:error] = "Se quiere dar de alta un titular y ya existe un interino"          
          elsif @caso == 4 then
            flash[:error] = "Se quiere dar de alta un interino y ya existe"          
          elsif @caso == 5 then 
            flash[:error] = "Se quiere dar de alta un interino y ya existe un titular"          
          elsif @caso == 7 then 
            flash[:error] = "El cargo que se quiere reemplazar no se encuentra con licencia sin goce de haberes"          
          elsif @caso == 9 then
            flash[:error] = "El cargo que se quiere suplantar no se encuentra con licencia con goce de haberes"          
          end
          @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id , @altas_bajas_hora.anio)      
        else
          if !@altas_bajas_hora.valid?
            @materias_permitidas = select_materias_permitidas(@altas_bajas_hora.plan_id , @altas_bajas_hora.anio)      
            format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }           
            format.html { render action: 'index' }
          end
        end        
      end
      format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }           
      format.html { render action: 'index' } 
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
    @nombres = params["nombres"]
    @apellidos = params["apellidos"]
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
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.apeynom = "#{@apellidos} #{@nombres}"
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento    
    end
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.secuencia = params[:altas_bajas_hora][:secuencia]
    @altas_bajas_hora.fecha_alta = params[:altas_bajas_hora][:fecha_alta]
    @altas_bajas_hora.fecha_baja = params[:altas_bajas_hora][:fecha_baja]
    @altas_bajas_hora.situacion_revista = params[:altas_bajas_hora][:situacion_revista]
    @altas_bajas_hora.horas = params[:altas_bajas_hora][:horas]
    @altas_bajas_hora.ciclo_carrera = params[:altas_bajas_hora][:ciclo_carrera]
    @altas_bajas_hora.anio = params[:altas_bajas_hora][:anio]
    @altas_bajas_hora.division = params[:altas_bajas_hora][:division]
    @altas_bajas_hora.turno = params[:altas_bajas_hora][:turno]
    @altas_bajas_hora.plan_id = params[:altas_bajas_hora][:plan_id]
    @altas_bajas_hora.materium_id = params[:altas_bajas_hora][:materium_id]    
    @materia = Materium.find(params[:altas_bajas_hora][:materium_id])
    @altas_bajas_hora.codificacion = @materia.codigo
    @altas_bajas_hora.lugar_pago_id = params[:altas_bajas_hora][:lugar_pago_id]
    @altas_bajas_hora.grupo_id = params[:altas_bajas_hora][:grupo_id]
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
        #debugger
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
   #@altas_bajas_horas.horas = params[:horas]
    @altas_bajas_horas.ciclo_carrera = Plan.where(:id => params[:plan_id]).first.codigo
    @altas_bajas_horas.plan_id = params[:plan_id]
    @altas_bajas_horas.anio = params[:anio]
    @altas_bajas_horas.division = params[:division]
    @altas_bajas_horas.materium_id = params[:materium_id]
    @altas_bajas_horas.codificacion = Materium.where(:id => params[:materium_id]).first.codigo
    @altas_bajas_horas.grupo_id = params[:grupo_id]
    @altas_bajas_horas.oblig = params[:oblig]
    @altas_bajas_horas.observaciones = params[:observaciones]
    @altas_bajas_horas.estado = params[:estado]


   respond_to do |format|
        if @persona.save then       
          if @altas_bajas_horas.save then
            format.html { redirect_to altas_bajas_horas_modificacion_path, notice: 'Registro actualizado correctamente' }
            format.json { render action: 'modificacion', status: :created, location: @altas_bajas_horas }
          else
            @planes_permitidos = select_planes_permitidos
            @materias_permitidas = select_materias_permitidas(@altas_bajas_horas.plan_id, @altas_bajas_horas.anio)
            format.html { render action: 'modificacion' }
            #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
            format.json { render json: @altas_bajas_horas.errors, status: :unprocessable_entity }
            #respond_with(@altas_bajas_hora, :location => altas_bajas_horas_path)  
          end        
        else
          @planes_permitidos = select_planes_permitidos
          @materias_permitidas = select_materias_permitidas(@altas_bajas_horas.plan_id, @altas_bajas_horas.anio)
          format.html { render action: 'modificacion' }
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
          if abh['escuela'] == 702 then
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

  def importar_recibos
    # Conexion a la base
    @client = Mysql2::Client.new(:host => "172.16.0.19", :username => "guest", :password => "guest", :database => "mec")

    # Recupera el mes actual
    mes = Date.today.month

    # Recupera el año actual
    anio = Date.today.year

    # Verifica si el mes actual es enero
    if mes == 1 then
      mes = 12
      anio = anio - 1
    else
      mes = mes - 1
    end

    mes = mes.to_s
    anio = anio.to_s

    escuela = 702
    escuela = escuela.to_s

    puts "1 - Realizando las consultas a la base MEC"

    # Recibos de MEC
    recibos = @client.query("SELECT nume_docu, tipo_docu, secuencia, apynom, escuela, mes, anio, empresa FROM recibos where (secuencia != 0 and mes = "+mes+" and anio = "+anio+" and escuela = "+escuela+")").to_a

    # Detalle de los recibos con la cantidad de horas catedras
    recibos_detalles = @client.query("SELECT nume_docu, secuencia, escuela, importe FROM detalle r where (codigo = 2808 and mes = "+mes+" and anio = "+anio+" and escuela = "+escuela+")").to_a

    # Padron de horas
    padhc = @client.query("SELECT nume_docu, escuela, ciclo, curso, division, materia, secuencia, estado, fecha_ing, fecha_alta, fecha_baja FROM padhc where escuela = "+escuela).to_a

    #recibos.select {|r| r["nume_docu"] == 17759477 and r["nume_docu"] == 000}

    puts "2 - Procesando los codigos de materias y las horas de los recibos"

    # Recorre todos los recibos para actualizar la cantidad de horas y el codigo de materia
    recibos.each do |r|

      #Recorre el detalle de los recibos buscando la cantidad de horas catedras
      r['horas'] = nil
      recibos_detalles.each do |rd|
        if r['nume_docu'] == rd['nume_docu'] and r['escuela'] == rd['escuela'] and r['secuencia'] == rd['secuencia']
          r['horas'] = rd['importe']
        end
      end

      #Recorre el padron de horas buscando el codigo de materia
      r['materia'] = nil
      padhc.each do |p|
        if r['nume_docu'] == p['nume_docu'] and r['escuela'] == p['escuela'] and r['secuencia'] == p['secuencia']
          r['materia'] = p['materia']
        end
      end

    end

    puts "3 - Cargando los datos en la base"

    # Recorremos el conjunto de objetos y captura las transacciones
    AltasBajasHora.transaction do
      PeriodoLiqHora.transaction do

        # Inicializo para compapara al final
        @periodo_recibo = "nada"

        recibos.each do |recibo|

          # Recupero el agente del recibo
          @agente = Persona.where(nro_documento: recibo['nume_docu'].to_i).first()

          # Verifico que el agente este cargado
          if @agente != nil then

            # Recupero las Altas/Bajas del agente
            @horas_agente = AltasBajasHora.where(persona_id: @agente.id).includes(:establecimiento)

            # Verifico que el agente tenga horas
            if @horas_agente != nil then

              @primer_recibo = true
              
              # Recorro cada una de las horas que tiene el agente y comparo la secuencia
              @horas_agente.each do |horas|
                # Si la secuencia y la escuela coinciden, hay unicidad
                if recibo['secuencia'] != 0 and recibo['secuencia'] == horas.secuencia and recibo['escuela'] == horas.establecimiento.codigo_jurisdiccional.to_i
                  if PeriodoLiqHora.where(mes: mes, anio: anio, altas_bajas_hora_id: horas.id).count == 0
                    @periodo_recibo = PeriodoLiqHora.new(mes: mes, anio: anio, altas_bajas_hora_id: horas.id)
                    @periodo_recibo.save!
                  end
                  @primer_recibo = false
                  break
                end
              end

              # Si es la primera vez que cobra, entonces hay que cargar la secuencia en AltasBajasHora
              if @primer_recibo == true

                #Recorro todas las horas del agente
                @horas_agente.each do |horas|
                  if recibo['escuela'] == horas.establecimiento.codigo_jurisdiccional.to_i and recibo['horas'] == horas.horas and recibo['materia'] == horas.codificacion
                    if PeriodoLiqHora.where(mes: mes, anio: anio, altas_bajas_hora_id: horas.id).count == 0
                      horas.update(secuencia: recibo['secuencia'])
                      @periodo_recibo = PeriodoLiqHora.new(mes: mes, anio: anio, altas_bajas_hora_id: horas.id)
                      @periodo_recibo.save!
                    end
                    @primer_recibo = false
                    break
                  end
                end
              end
            end
          end
        end
      end
    end

    puts "4 - Termino!!"

    respond_to do |format|
      if @periodo_recibo != nil and @periodo_recibo != "nada"
        format.html { redirect_to altas_bajas_horas_path, notice: 'Se realizo correctamente la importación de los recibos del mes ' }
      elsif @periodo_recibo != nil and @periodo_recibo == "nada"
        format.html { redirect_to altas_bajas_horas_path, notice: 'La base se encuentra actualizada' }
      else
        format.html { redirect_to altas_bajas_horas_path, alert: 'Importacion incorrecta' }
      end
    end
  end

  def dar_baja
    #Estado, necesario para Minsiterio de economia
    @altas_bajas_hora.estado = "BAJ"
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
      #Estado, necesario para Minsiterio de economia
      @altas_bajas_hora.estado = "ALT"
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
          @lote_impresion = LoteImpresion.where(fecha_impresion: nil, tipo_id: 1).last
          if @lote_impresion == nil
            @lote_impresion = LoteImpresion.create(fecha_impresion: nil, observaciones: nil, tipo_id: 1)
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
      @altas_bajas_hora = AltasBajasHora.find(params[:id])
    end

    def altas_bajas_hora_params
      params.require(:altas_bajas_hora).permit(:establecimiento_id, :mes_periodo, :anio_periodo, :persona_id, :secuencia, :fecha_alta, :fecha_baja, :situacion_revista, :horas, :ciclo_carrera, :anio, :division, :turno, :codificacion, :oblig, :observaciones, :empresa_id, :lugar_pago_id, :estado, :con_movilidad, :plan_id, :materium_id, :grupo_id)
    end


end