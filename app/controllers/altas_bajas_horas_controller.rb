class AltasBajasHorasController < ApplicationController
  before_action :set_altas_bajas_hora, only: [:show, :edit, :update, :destroy, :dar_baja]

  respond_to :html

  def index
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
      @persona.save
    else
      @persona.tipo_documento_id = @tipo_documento
      @persona.nro_documento = @dni
      @persona.nombres = @nombres
      @persona.apellidos = @apellidos
      @persona.cuil = @cuil
      @persona.fecha_nacimiento = @fecha_nacimiento
      @persona.save
    end
    @altas_bajas_hora = AltasBajasHora.new(altas_bajas_hora_params)
    @altas_bajas_hora.persona_id = @persona.id
    @altas_bajas_hora.establecimiento_id = @establecimiento.id
    @altas_bajas_hora.save
    #respond_with(@altas_bajas_hora)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_path, notice: 'Alta correctamente realizada' }
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
    @altas_bajas_hora.update(:fecha_baja => Date.today)
    respond_to do |format|
      format.html { redirect_to altas_bajas_horas_index_bajas_path, notice: 'Baja correctamente realizada' }
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
