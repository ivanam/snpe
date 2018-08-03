class LicenciaController < ApplicationController
  load_and_authorize_resource
  autocomplete :persona, :apeynom, :full => false, :extra_data => [:apeynom, :nro_documento], :display_value => :to_s
  before_action :set_licencium, only: [:show, :edit, :update, :destroy]
  

  respond_to :html



  def get_autocomplete_items
    render json: Persona.where('nro_documento like "%' + params[:term] + '%" or apeynom like "%' + params[:term] + '%"').pluck(:apeynom).to_json
  end

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
    if params["rango"] == "" or params["rango"] == nil
      @mindate_year = Date.today.year
      @mindate = Date.today.to_s
      @maxdate = Date.today.to_s
      @res = listado_de_licencias(@mindate, @maxdate)
    else
      @rango = params["rango"]
      @mindate, @maxdate = Util.max_min_periodo(@rango)
       @mindate2 = @mindate.to_s
       @maxdate2 = @maxdate.to_s

      @res = listado_de_licencias(@mindate, @maxdate)
    end  
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicencia2Datatable.new(view_context, { query: @res}) }
    end
  end

  def parte_diario
    if params["rango"] == "" or params["rango"] == nil
      @mindate_year = Date.today.year
      @mindate = Date.today.to_s
      @maxdate = Date.today.to_s

      @res = listado_parte_diario(@mindate, @maxdate)
    else
      @rango = params["rango"]
      @mindate, @maxdate = Util.max_min_periodo(@rango)
       @mindate2 = @mindate.to_s
       @maxdate2 = @maxdate.to_s

      @res = listado_parte_diario(@mindate, @maxdate)
    end
    respond_to do |format|
    format.pdf do
      render :pdf => 'parte_diario',
      #:header => { :html => { :template => 'layouts/_header_lic.html.erb'} }, 
      :template => 'licencia/parte_diario_pdf.html.erb',
      :layout => 'lic_pdf.html.erb',
      :orientation => 'Landscape',# default Portrait
      :page_size => 'Legal', # default A4
      :footer => { :right => 'Pagina: [page]' },
       #margin: { top: 40 },
      :show_as_html => params[:debug].present?
    end  
      format.xls 
    end
  end

   def listado_licencias_cnds
     if params["rango"] == "" or params["rango"] == nil
       @mindate_year2 = Date.today.year
       @mindate2 = Date.today.to_s
       @maxdate2 = Date.today.to_s
       @res2 = listado_de_licencias_cargonds(@mindate2, @maxdate2)

     else
       @rango2 = params["rango"]
       @mindate, @maxdate = Util.max_min_periodo(@rango2)
       @mindate2 = @mindate.to_s
       @maxdate2 = @maxdate.to_s

       @res2 = listado_de_licencias_cargonds(@mindate2, @maxdate2)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadosLicenciaCargosnds2Datatable.new(view_context, { query: @res2}) }
    end
  end

  def listado_licencias_carg
     if params["rango"] == ""
       @mindate_year3 = Date.today.year
       @mindate3 = Date.today.to_s
       @maxdate3 = Date.today.to_s
       @res3 = listado_de_licencias_cargo(@mindate3, @maxdate3)
     else 
       @rango3 = params["rango"]
       @mindate, @maxdate = Util.max_min_periodo(@rango3)
       @mindate2 = @mindate.to_s
       @maxdate2 = @maxdate.to_s

       @res3 = listado_de_licencias_cargo(@mindate3, @maxdate3)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaCargos2Datatable.new(view_context, { query: @res3}) }
    end
  end




#----------------------------------------------licencias sin goce---------------------------------------------------------------
def obtenerdatarange
    if params["rango"] == "" or params["rango"] == nil
      @res = Util.max_min_periodo(@rango)
    else
      @res = params["rango"]
    end  

    @ras= [@res]
    render json: @ras
end

def obtenerdatarange2
    if params["rango"] == "" or params["rango"] == nil
      @res = Util.max_min_periodo(@rango)
    else
      @res = params["rango"]
    end  

    @ras= [@res]
    render json: @ras
end

def obtenerdatarange3
    if params["rango"] == "" or params["rango"] == nil
      @res = Util.max_min_periodo(@rango)
    else
      @res = params["rango"]
    end  

    @ras= [@res]
    render json: @ras
end


def listado_licencias_todas_lic
  

  @dni=params[:dni]
  if @dni == '' or @dni == ""
    @dni = nil
  end  
  @art=params[:select_articulo_horas]
  if @art == '' or @art == ""
     @art = nil
  end
    if params["rango"] == "" or params["rango"] == "undefined"
      @mindate_year = Date.today.year
      @mindate = Date.today.to_s
      @maxdate = Date.today.to_s
      @res = listado_de_licencias_sg(@mindate, @maxdate, @dni, @art)

    else
      @rango = params["rango"]
      @mindate, @maxdate = Util.max_min_periodo(@rango)
      @res = listado_de_licencias_sg(@mindate, @maxdate, @dni, @art)
    end  
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaDatatable.new(view_context, { query: @res}) }
    end
  end

  def listado_licencias_cnds_sg
  @dni2=params[:dni2]
  if @dni2 == '' or @dni2 == ""
    @dni2 = nil
  end  
  @art2=params[:select_articulo_cargos_no_docente]
  if @art2 == '' or @art2 == ""
     @art2 = nil
  end
     if params["rango2"] == ""
       @mindate_year2 = Date.today.year
       @mindate2 = Date.today.to_s
       @maxdate2 = Date.today.to_s
       @res2 = listado_de_licencias_cargonds_sg(@mindate2, @maxdate2, @dni2, @art2)
     else
       @rango2 = params["rango2"]
       @mindate2, @maxdate2 = Util.max_min_periodo(@rango2)
       @res2 = listado_de_licencias_cargonds_sg(@mindate2, @maxdate2, @dni2, @art2)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadosLicenciaCargosndsDatatable.new(view_context, { query: @res2}) }
    end
  end

  def listado_licencias_carg_sg
  @dni3=params[:dni3]
  if @dni3 == '' or @dni3 == ""
    @dni3 = nil
  end  
  @art3=params[:select_articulo_cargos]
  if @art3 == '' or @art3 == ""
     @art3 = nil
  end
     if params["rango3"] == ""  or params["rango3"] == "undefined" or params["rango3"] == nil 
       @mindate_year3 = Date.today.year
       @mindate3 = Date.today.to_s
       @maxdate3 = Date.today.to_s
       @res3 = listado_de_licencias_cargo_sg(@mindate3, @maxdate3, @dni3, @art3)
     else 
       @rango3 = params["rango3"]
       @mindate3, @maxdate3 = Util.max_min_periodo(@rango3)
       @res3 = listado_de_licencias_cargo_sg(@mindate3, @maxdate3, @dni3, @art3)
     end
    respond_to do |format|
      format.xls 
      format.html 
      format.json { render json: ListadoLicenciaCargosDatatable.new(view_context, { query: @res3}) }
    end
  end
#-----------------------------------------------------------licencias sin goce -----------------------------------------

  def listado_licencias_todas
    if params["rango"] == nil
      @mindate_year = Date.today.year
      @mindate4 = Date.today.to_s
      @maxdate4 = Date.today.to_s
      @res4 = listado_de_licencias_todas(@mindate4, @maxdate4)    
    else
      @rango4 = params["rango"]
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

  def cargos_licencia_permitida2
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
     @altbahora = AltasBajasHora.where(id: params['id_horas']).first
     @oficina = Establecimiento.where(id: @altbahora.establecimiento_id).first
     nro_oficina = @oficina.codigo_jurisdiccional
     @persona = Persona.where(id: @altbahora.persona_id).first
     nro_documento = @persona.nro_documento
    if params[:articulo] == "360"
      @licencia = Licencium.new(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Finalizada", anio_lic: params[:fecha_anio_lic], destino: params[:destino], observaciones: params[:observaciones], nro_documento: nro_documento, oficina: nro_oficina)
      cargo_guardado = AltasBajasHora.find(params[:id_horas]).update(establecimiento_id: params[:destino], estado: 'REU')
    else
      @licencia = Licencium.new(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic], observaciones: params[:observaciones], nro_documento: nro_documento, oficina: nro_oficina)
      cargo_guardado = true
    end
    if cargo_guardado && @licencia.save
      render json: 0
    else
      msg = @licencia.errors.full_messages.first
      render json: msg.to_json
    end
  end

   def guardar_licencia_horas2
    prestador2 = params[:prestador_2]
    @no_guarda = true
    @licencia_anterior= Licencium.where(altas_bajas_hora_id: params['id_horas'], vigente: 'vigente').last
    @altbahora = AltasBajasHora.where(id: params['id_horas']).first
    @persona = Persona.where(id: @altbahora.persona_id).first
    nro_documento = @persona.nro_documento
    @oficina = Establecimiento.where(id: @altbahora.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    @licencia = Licencium.new(altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic], nro_documento: nro_documento, oficina: nro_oficina)
    if @licencia_anterior.fecha_hasta == nil
        if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
          fecha = params[:fecha_inicio].to_date - 1
          @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador2)
        else
          @no_guarda = false
        end
    elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
         @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador2)
    else
      @no_guarda = false
    end
    if @no_guarda and @licencia.save
        render json: 0
      else
        msg = "La fecha de inicio debe ser mayor a la fecha desde de la anterior licencia"
        render json: msg.to_json
      end
    end 

   def guardar_licencia_obs
     lic = Licencium.where(:id => params["id_lic"]).first
     lic.observaciones = params["observaciones"]
     if lic.save 
        render json: 0
     else 
      msg = "error al guardar observaciones"
      render json: msg.to_json
     end
   end



  def guardar_licencia_cargos
    cargo = Cargo.where(id: params['id_cargos']).first
    secuencia= cargo.secuencia
    descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
    @persona = Persona.where(id: cargo.persona_id).first
    nro_documento = @persona.nro_documento
    @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    if ((params['articulo']=="352" or params['articulo']=="353" or params['articulo']=="354" or params['articulo']=="355" or params['articulo']=="356" or params['articulo']=="357" or params['articulo']=="358" or params['articulo']=="359") and secuencia != 1000)
      destino = cargo.id
      if params[:articulo] == "359" and params[:destino].to_i > 0
        destino = params[:destino]
      end  
      @licencia = Licencium.new(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1], destino: destino, observaciones: params[:observaciones],nro_documento: nro_documento, oficina: nro_oficina)
      if @licencia.save && Cargo.create!(establecimiento_id: destino, persona_id: cargo.persona_id, cargo: cargo.cargo, grupo_id: 100 , secuencia: 1000, fecha_alta: cargo.fecha_alta, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista,  anio:0, division: 0, turno: cargo.turno,   estado: 'REU' , observaciones: descripcion_articulo)
        render json: 0
      else
        render json: @licencia.errors.full_messages.first.to_json
      end
    elsif params[:articulo] == "360"
      @licencia = Licencium.new(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Finalizada", anio_lic: params[:fecha_anio_lic_1], destino: params[:destino],nro_documento: nro_documento, oficina: nro_oficina)
      if Cargo.find(params['id_cargos']).situacion_revista == "1-1" && @licencia.save && Cargo.find(params['id_cargos']).update(establecimiento_id: params[:destino], estado: 'REU')
        render json: 0
      else
        render json: "no se puede realizar el traslado".to_json
      end
    else
      @licencia = Licencium.new(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1], observaciones: params[:observaciones],nro_documento: nro_documento, oficina: nro_oficina)
      if @licencia.save
        render json: 0
      else
        render json: @licencia.errors.full_messages.first.to_json
      end
    end
  end


  def guardar_licencia_cargos2
  prestador_3 = params[:prestador_3]  
  @no_guarda = true
  secuencia=Cargo.where(id: params['id_cargos']).first.secuencia
  descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
  @licencia_anterior= Licencium.where(cargo_id: params['id_cargos'], vigente: 'vigente').last
  cargo = Cargo.where(id: params['id_cargos']).first 
  persona = Persona.where(id: cargo.persona_id).first
  nro_documento = persona.nro_documento
  @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
  nro_oficina = @oficina.codigo_jurisdiccional
  @licencia = Licencium.new(cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1], observaciones: params[:observaciones],nro_documento: nro_documento, oficina: nro_oficina)
    if @licencia_anterior.fecha_hasta == nil
        if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
          fecha = params[:fecha_inicio].to_date - 1
          @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
        else
          @no_guarda = false
        end
    elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
         @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
    else
      @no_guarda = false
    end
 
    if @no_guarda and @licencia.save
        render json: 0
      else
        if @no_guarda
          msg = "error en licencia"
        else
          msg = @licencia.errors.full_messages.first
        end
        render json: msg.to_json
      end
    end

  def guardar_licencia_cargos2_obs
  end

  

  def guardar_licencia_cargos_no_docentes
    turnocnds = CargoNoDocente.where(id: params['id_cargos_no_docentes']).first.turno
    cargonds = CargoNoDocente.where(id: params['id_cargos_no_docentes']).first
    descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
    secuencia= cargonds.secuencia
    cargondsid = cargonds.id
    persona = Persona.where(id: cargonds.persona_id).first
    nro_documento = persona.nro_documento
    @oficina = Establecimiento.where(id: cargonds.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    if (turnocnds == nil or turnocnds == "")
      msg = "El cargo auxiliar no tiene turno asignado"
      render json: msg.to_json
    end 
   if ((params['articulo']=="352" or params['articulo']=="353" or params['articulo']=="354" or params['articulo']=="355" or params['articulo']=="356" or params['articulo']=="357" or params['articulo']=="358" or params['articulo']=="359") and secuencia != 1000)
      destino = cargonds.id
      if params[:articulo] == "378" and params[:destino].to_i > 0
        destino = params[:destino]
      end
      @licencia = Licencium.new(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2], destino: destino, observaciones: params[:observaciones], nro_documento: nro_documento, oficina: nro_oficina)
      if @licencia.save && CargoNoDocente.create!(establecimiento_id: params[:destino], persona_id: cargonds.persona_id, cargo: cargonds.cargo, secuencia: 1000, fecha_alta: cargonds.fecha_alta, fecha_baja: cargonds.fecha_baja, situacion_revista: cargonds.situacion_revista, turno: cargonds.turno,   estado: 'REU' , observaciones: descripcion_articulo)
        render json: 0
      else
        render json: @licencia.errors.full_messages.first.to_json
      end
    elsif params[:articulo] == "377"
      cargondsid = cargonds.id
       @licencia = Licencium.new(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Finalizada", anio_lic: params[:fecha_anio_lic_2], destino: cargondsid, nro_documento: nro_documento, oficina: nro_oficina)
      if  @licencia.save && CargoNoDocente.find(params['id_cargos_no_docentes']).update(establecimiento_id: params[:destino], estado: 'REU')
        render json: 0
      else
        render json: "no se puede realizar el traslado".to_json
      end
    else
      @licencia = Licencium.new(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2], observaciones: params[:observaciones], nro_documento: nro_documento, oficina: nro_oficina)
      if @licencia.save
        render json: 0
      else
        render json: @licencia.errors.full_messages.first.to_json
      end
    end
  end


  def guardar_licencia_cargos_no_docentes2
    prestador_4 = params[:prestador_4] 
    @no_guarda = true
    @licencia_anterior= Licencium.where(cargo_no_docente_id: params['id_cargos_no_docentes'], vigente: 'vigente').last
    cargonds = CargoNoDocente.where(id: params['id_cargos_no_docentes']).first
    persona = Persona.where(id: cargonds.persona_id).first
    nro_documento = persona.nro_documento
    @oficina = Establecimiento.where(id: cargonds.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    @licencia = Licencium.new(cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2], observaciones: params[:observaciones], nro_documento: nro_documento, oficina: nro_oficina)
    if @licencia_anterior.fecha_hasta == nil
        if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
          fecha = params[:fecha_inicio].to_date - 1
          @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_4)
        else
          @no_guarda = false
        end
    elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
         @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_4)
    else
      @no_guarda = false
    end

    if @no_guarda and @licencia.save
        render json: 0
    else
      
        msg = "error en la licencia"
        render json: msg.to_json
      end
    end

  def guardar_licencia_cargos_no_docentes2_obs
  end



  def guardar_licencia_final
    @licencia = Licencium.where(id: params[:id_lic]).first
    baja = params[:por_baja] == "1"
    prestador = params[:prestador]
    observaciones = params[:observaciones]
    if !@licencia.update(fecha_hasta: params[:fecha_fin], vigente: "Finalizada", por_baja: baja, prestador_id: prestador, observaciones: observaciones)
      msg = @licencia.errors.full_messages.first
      msg = "No se puede finalizar la licencia. Posee suplente. O no corresponde la situación de revista"
    end

    render json: msg.to_json
  end

  def editar_comentario_licencia_final
    @licencia = Licencium.where(id: params[:id_lic]).first
    observaciones = params[:observaciones]
    if !@licencia.update(observaciones: observaciones)
      msg = @licencia.errors.full_messages.first
      msg = "No se puede editar el comentario"
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
   
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias.to_i - @dias
    render json:  @dias_disponibles
  end

  def buscar_articulo_dias_cargo
    @licencia_cargo = Licencium.where(cargo_id: params[:id_cargos])
    @licencia_articulo = @licencia_cargo.where(articulo_id: params[:id_articulo], vigente: "Finalizada")
    @dias=0
    @licencia_articulo.each do |l|
      @dias = @dias + (l.fecha_hasta - l.fecha_desde).to_i
    end
    @dias_disponibles = Articulo.where(id: params[:id_articulo]).first.cantidad_maxima_dias.to_i - @dias
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

  def chequear_finalizada
    @lic = Licencium.where(:id => params[:id]).first
    @lic.update!(finalizada: true, user_cheq_finalizada_id: current_user.id, fecha_cheq_finalizada: DateTime.now)
    render json: @lic

  end

  def chequear_cargada
    @lic = Licencium.where(:id => params[:id]).first
    @lic.update!(cargada: true, user_cheq_cargada_id: current_user.id, fecha_cheq_cargada: DateTime.now)
    render json: @lic

  end

  def traslados

    mes = params[:mes] 
    anio = params[:anio]
    if mes == nil
      mes = Date.today.month.to_s
    end
    if anio == nil
      anio = Date.today.year.to_s
    end
    fecha_i = anio+"-"+mes+"-01"
    fecha_f = anio+"-"+mes+"-31"
    @licencias_cargos = Licencium.where.not(cargo_id: nil).where("fecha_desde >= '" + fecha_i + "' and fecha_desde <= '"+ fecha_f +"'").where(articulo_id: [359,360])
  end

  def sin_goce
    @mes = params[:mes] 
    @anio = params[:anio]
    @tipo_cargo = params[:tipo_cargo]

    if @mes == nil
      @mes = Date.today.month.to_s
    end
    if @anio == nil
      @anio = Date.today.year.to_s
    end
    fecha_i = @anio+"-"+@mes+"-01"
    fecha_f = @anio+"-"+@mes+"-31"
    articulo_ids = Articulo.where(con_goce: false).map(&:id)
    licencias = Licencium.where(articulo_id: articulo_ids)
    if @tipo_cargo == nil || @tipo_cargo == "horas"
      licencias = licencias.where.not(altas_bajas_hora_id: nil)
    elsif @tipo_cargo == "cargos"
      licencias = licencias.where.not(cargo_id: nil)
    elsif @tipo_cargo == "cargos no docente"
      licencias = licencias.where.not(cargo_no_docente_id: nil)
    end
    @licencia_alta = licencias.where("fecha_cheq_cargada >= '" + fecha_i + "' and fecha_cheq_cargada <= '"+ fecha_f +"'")
    @licencia_fin = licencias.where("fecha_cheq_finalizada >= '" + fecha_i + "' and fecha_cheq_finalizada <= '"+ fecha_f +"'")
    respond_to do |format|
    format.pdf do
      render :pdf => 'sin_goce', 
      :template => 'licencia/sin_goce_pdf.html.erb',
      :layout => 'pdf.html.erb',
      :orientation => 'Landscape',# default Portrait
      :page_size => 'Legal', # default A4
      :show_as_html => params[:debug].present?
    end
    format.html 
    end 
  end


  private
    def set_licencium
      @licencium = Licencium.find(params[:id])
    end

    def licencium_params
      params.require(:licencium).permit(:altas_bajas_hora_id, :fecha_desde, :fecha_hasta, :articulo_id, :cargo_id, :cargo_no_docente_id, :vigente, :prestador_id, :observaciones, :anio_lic, :destino)
    end
end
