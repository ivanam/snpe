class LicenciaController < ApplicationController
  before_action :set_licencium, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index

    respond_to do |format|
      format.html
      format.json { render json: LicenciaDatatable.new(view_context, { query: Licencium.all }) }
    end
  end

  def show
    respond_with(@licencium)
  end

  def new
    @licencium = Licencium.new
    respond_with(@licencium)
  end

  def edit
  end

  def create

    @licencium = Licencium.new(licencium_params)
    @licencium.save
    respond_with(@licencium)
  end

  def update
    @licencium.update(licencium_params)
    respond_with(@licencium)
  end

  def destroy
    @licencium.destroy
    respond_with(@licencium)
  end

  #Reporte de todas las licencias de todos los establecimientos
  def listado_licencias
    if params["rango"] == nil
      @mindate_year = Date.today.year
      @mindate = Date.today.to_s
      @maxdate = Date.today.to_s
      @res = listado_de_licencias(@mindate, @maxdate)
    else
      @rango = params["rango"]
      @mindate, @maxdate = Util.max_min_periodo(@rango)
      @res = listado_de_licencias(@mindate, @maxdate)
    end  
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaDatatable.new(view_context, { query: @res}) }
    end
  end

   def listado_licencias_cnds
     if params["rango2"] == nil
       @mindate_year2 = Date.today.year
       @mindate2 = Date.today.to_s
       @maxdate2 = Date.today.to_s
       @res2 = listado_de_licencias_cargonds(@mindate2, @maxdate2)
     else
       @rango2 = params["rango2"]
       @mindate2, @maxdate2 = Util.max_min_periodo(@rango2)
       @res2 = listado_de_licencias_cargonds(@mindate2, @maxdate2)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadosLicenciaCargosndsDatatable.new(view_context, { query: @res2}) }
    end
  end

  def listado_licencias_carg
     if params["rango3"] == nil
       @mindate_year3 = Date.today.year
       @mindate3 = Date.today.to_s
       @maxdate3 = Date.today.to_s
       @res3 = listado_de_licencias_cargo(@mindate3, @maxdate3)
     else 
       @rango3 = params["rango3"]
       @mindate3, @maxdate3 = Util.max_min_periodo(@rango3)
       @res3 = listado_de_licencias_cargo(@mindate3, @maxdate3)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaCargosDatatable.new(view_context, { query: @res3}) }
    end
  end

#----------------------------------------------licencias sin goce---------------------------------------------------------------
def listado_licencias_todas_lic
    if params["rango"] == nil
      @mindate_year = Date.today.year
      @mindate = Date.today.to_s
      @maxdate = Date.today.to_s
      @res = listado_de_licencias_sg(@mindate, @maxdate)
    else
      @rango = params["rango"]
      @mindate, @maxdate = Util.max_min_periodo(@rango)
      @res = listado_de_licencias_sg(@mindate, @maxdate)
    end  
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaDatatable.new(view_context, { query: @res}) }
    end
  end

   def listado_licencias_cnds_sg
     if params["rango2"] == nil
       @mindate_year2 = Date.today.year
       @mindate2 = Date.today.to_s
       @maxdate2 = Date.today.to_s
       @res2 = listado_de_licencias_cargonds_sg(@mindate2, @maxdate2)
     else
       @rango2 = params["rango2"]
       @mindate2, @maxdate2 = Util.max_min_periodo(@rango2)
       @res2 = listado_de_licencias_cargonds_sg(@mindate2, @maxdate2)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadosLicenciaCargosndsDatatable.new(view_context, { query: @res2}) }
    end
  end

  def listado_licencias_carg_sg
     if params["rango3"] == nil
       @mindate_year3 = Date.today.year
       @mindate3 = Date.today.to_s
       @maxdate3 = Date.today.to_s
       @res3 = listado_de_licencias_cargo_sg(@mindate3, @maxdate3)
     else 
       @rango3 = params["rango3"]
       @mindate3, @maxdate3 = Util.max_min_periodo(@rango3)
       @res3 = listado_de_licencias_cargo_sg(@mindate3, @maxdate3)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaCargosDatatable.new(view_context, { query: @res3}) }
    end
  end
#-----------------------------------------------------------licencias sin goce -----------------------------------------

  def listado_licencias_todas
    if params["rango4"] == nil
      @mindate_year = Date.today.year
      @mindate4 = Date.today.to_s
      @maxdate4 = Date.today.to_s
      @res4 = listado_de_licencias_todas(@mindate4, @maxdate4)    
    else
      @rango4 = params["rango4"]
      @mindate4, @maxdate4 = Util.max_min_periodo(@rango4)
      @res4 = listado_de_licencias_todas(@mindate4, @maxdate4) 
   end
      respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaTodasDatatable.new(view_context, { query: @res4}) }
    end
  end
  
  
  def cargos_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: CargosLicenciaPermitidaDatatable.new(view_context, { query: cargos_persona_permitida(@dni)}) }
    end
  end


  def cargos_no_docentes_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
        format.json { render json: CargoNoDocentesLicenciaPermitidaDatatable.new(view_context, { query: cargos_no_docente_persona_permitida(@dni)}) }
    end
  end

  def altas_bajas_horas_licencia_permitida
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: AltasBajasHoraLicenciaPermitidaDatatable.new(view_context, { query: horas_persona_permitida(@dni)}) }
    end
  end

  def licencia_dadas
    @dni=params[:dni]
    #@altas = Licencium.where{(altas_bajas_hora_id == AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))) | (cargo_id == Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])))}
    respond_to do |format|
      format.json { render json: LicenciaDatatable.new(view_context, { query: licencias(@dni)}) }
    end
  end 

  def guardar_licencia_horas

    @licencia = Licencium.create(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic])
    render json: 0
  end 

  def guardar_licencia_cargos
  secuencia=Cargo.where(id: params['id_cargos']).first.secuencia
  descripcion_articulo= Articulo.where(id: params['articulo']).first.descripcion
  if ((params['articulo']=="352" or params['articulo']=="353" or params['articulo']=="354" or params['articulo']=="355" or params['articulo']=="356" or params['articulo']=="357" or params['articulo']=="358" or params['articulo']=="359" or params['articulo']=="360") and secuencia != 1000)
    cargo=Cargo.where(id: params['id_cargos']).first
    Cargo.create!(establecimiento_id: cargo.establecimiento_id, persona_id: cargo.persona_id, cargo: cargo.cargo, grupo_id: 100 , secuencia: 1000, fecha_alta: cargo.fecha_alta, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista,  anio:0, division: 0, turno: cargo.turno,   estado: cargo.estado , observaciones:descripcion_articulo )
    @licencia = Licencium.create(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1])
    render json: 0
  else
    @licencia = Licencium.create(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1])
    render json: 0
  end
  end
   
  def guardar_licencia_cargos_no_docentes
    @licencia = Licencium.create!(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2  ])
    if @licencia.save then
      render json: 0
      else
      format.json { render json: @licencia, turno: :unprocessable_entity }
      end      
  end

  def guardar_licencia_final 


    @licencia = Licencium.where(id: params[:id_lic]).first
    baja = params[:por_baja] == "1"
    prestador = params[:prestador]

    if !@licencia.update(fecha_hasta: params[:fecha_fin], vigente: "Finalizada", por_baja: baja, prestador_id: prestador)
      msg = @licencia.errors.full_messages.first
      msg = "No se puede cancelar la licencia. Posee suplente"
    else
      if @licencia.altas_bajas_hora_id != nil 
        id_lic =@licencia.altas_bajas_hora_id
        alta_horas = AltasBajasHora.where(:id => id_lic).first
        @estado = Estado.where(:descripcion => "Notificado_Baja").first
        AltasBajasHoraEstado.create(estado_id: @estado.id, alta_baja_hora_id: alta_horas.id, user_id: current_user.id) 
        msg = ''
      elsif @licencia.cargo_id != nil
        id_lic =@licencia.cargo_id
        cargos = Cargo.where(:id => id_lic).first
        @estado = Estado.where(:descripcion => "Notificado_Baja").first
        CargoEstado.create(estado_id: @estado.id, cargo_id: cargos.id, user_id: current_user.id) 
        msg = ''
      end

        
    end

    render json: msg.to_json
  end 

  def cancelar_licencia
    @licencia = Licencium.where(id: params[:id_lic]).first
    baja = params[:por_baja] == "1"
    if !@licencia.update(vigente: "Cancelada", por_baja: baja )
      msg = @licencia.errors.full_messages.first
      msg = "No se puede cancelar la licencia. Posee suplente"
    else
      msg = ''
    end

    render json: msg.to_json
  end

  def buscar_articulo_dias_hora
    @licencia_hora = Licencium.where(altas_bajas_hora_id: params[:id_horas])
    @licencia_articulo = @licencia_hora.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i + 1
    end
   
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  def buscar_articulo_dias_cargo
    @licencia_cargo = Licencium.where(cargo_id: params[:id_cargos])
    @licencia_articulo = @licencia_cargo.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i
    end
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  def buscar_articulo_dias_cargo_no_docente
    @licencia_cargo_no_docente = Licencium.where(cargo_no_docente_id: params[:id_cargos_no_docentes])
    @licencia_articulo = @licencia_cargo_no_docente.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i
    end
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias - @dias
    render json:  @dias_disponibles
  end

  def editar_licencias_cnds
    @persona = CargoNoDocente.where(:id => record.cargo_no_docente_id.to_i).first.persona
    if @persona.count > 0
      if params["post"]["calle"] != nil
        @persona.first.update(calle: params["post"]["calle"])
      end
    end  
  end 

  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :fecha_desde, :fecha_hasta, :articulo_id, :cargo_id, :cargo_no_docente_id, :vigente, :prestador_id, :observaciones, :anio_lic)
    end
end
