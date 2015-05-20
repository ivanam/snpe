class AltasBajasHorasController < ApplicationController
  before_action :set_altas_bajas_hora, only: [:show, :edit, :update, :destroy, :dar_baja]

  respond_to :html

  def index
    if @altas_bajas_hora == nil
      @altas_bajas_hora = AltasBajasHora.new
    end
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas }) }
    end
  end

  def index_bajas
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaPermitidaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def index_notificadas
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraNotificadaDatatable.new(view_context, { query: altas_bajas_horas_permitidas_altas_notificadas }) }
    end
  end

  def index_personal_activo
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraDatatable.new(view_context, { query: altas_bajas_horas_permitidas_bajas }) }
    end
  end

  def index_bajas_efectivas
    respond_to do |format|
      format.html
      format.json { render json: AltasBajasHoraBajaEfectivaDatatable.new(view_context, { query: altas_bajas_horas_efectivas_bajas }) }
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
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.establecimiento_id = @establecimiento.id
    @estado = Estado.where(:descripcion => "Ingresado").first

    respond_to do |format|
      if @persona.save then       
          if @altas_bajas_hora.save then
            AltasBajasHoraEstado.create(:estado_id => @estado.id, :alta_baja_hora_id => @altas_bajas_hora.id)
            format.html { redirect_to altas_bajas_horas_path, notice: 'Alta correctamente realizada' }
            format.json { render action: 'show', status: :created, location: @altas_bajas_hora }
          else
            format.html { render action: 'index' }
            #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
            format.json { render json: @altas_bajas_hora.errors, status: :unprocessable_entity }
            #respond_with(@altas_bajas_hora, :location => altas_bajas_horas_path)  
          end        
      else
          format.html { render action: 'index' }
          #format.html { redirect_to altas_bajas_horas_path, alert: 'El Alta no pudo concretarse por el siguiente error: ' + @altas_bajas_hora.errors.full_messages.to_s.tr('[]""','')}
          #debugger
          format.json { render json: @persona.errors, status: :unprocessable_entity }
      end
    end
  end

  def editar_alta
    @altas_bajas_hora = AltasBajasHora.find(params[:id])
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
            AltasBajasHoraEstado.create(:estado_id => @estado.id, :alta_baja_hora_id => @altas_bajas_hora.id)
            format.html { redirect_to altas_bajas_horas_path, notice: 'Alta correctamente realizada' }
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

    # Aca el result es un conjunto de objetos, asi que joya =) (fijate la parte del where, nose si es asi. Yo probe local con las query de abajo)
    results = @client.query("SELECT * FROM padhc where estado='ALT'")     

    #@@client = Mysql2::Client.new(:host => "localhost", :username => "root", :password => "root", :database => "snpe")
    #results = @@client.query("SELECT * FROM establecimientos LIMIT 0,1000")

    # Recorremos el conjunto de objetos
    results.each do |abh|
      # Aca deje algo medio armado, no puedo probar porque faltan datos. Escuela no esta el cue y algun otro mas
      # los campos de abh se recorren con ['nombre_columna'] ejemplo, abh['nume_docu']
      @establecimiento = Establecimiento.where(:codigo_jurisdiccional => abh['escuela']).first
      @persona = Persona.where(:nro_documento => abh['nume_docu']).first
      if not(@establecimiento == nil or @persona == nil) then
        @data = AltasBajasHora.new(:establecimiento_id => @establecimiento.id, :persona_id => @persona.id, :secuencia => abh['secuencia'], :fecha_alta => abh['fecha_alta'], :fecha_baja => abh['fecha_baja'], :situacion_revista => nil, :horas => abh['hora_cate'], :ciclo_carrera => abh['ciclo'], :anio => abh['curso'], :division => abh['division'], :turno => abh['turno'], :codificacion => abh['materia'], :oblig => nil, :observaciones => nil)
        @data.save
      end
    end
    respond_to do |format|
      format.html
      format.html { redirect_to altas_bajas_horas_path, notice: 'Importacion correcta' }
    end
  end

  def dar_baja
    #debugger
    @altas_bajas_hora.update(:fecha_baja => params[:altas_bajas_hora][:fecha_baja])
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_index_bajas_path, notice: 'Baja correctamente realizada' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def notificar
    #debugger
    @estado = Estado.where(:descripcion => "Notificado").first
    AltasBajasHoraEstado.create( :alta_baja_hora_id => params["id"], :estado_id => @estado.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Notificado correctamente' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def cancelar
    #debugger
    @estado = Estado.where(:descripcion => "Cancelado").first
    AltasBajasHoraEstado.create( :alta_baja_hora_id => params["id"], :estado_id => @estado.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, alert: 'Cancelado' }
      format.json { head :no_content } # 204 No Content
    end
  end

  def chequear
    #debugger
    @estado = Estado.where(:descripcion => "Chequeado").first
    AltasBajasHoraEstado.create( :alta_baja_hora_id => params["id"], :estado_id => @estado.id)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta chequeada' }
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
