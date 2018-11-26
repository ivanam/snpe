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



  def historial
    @dni=params[:dni]
    
  end


  def historial_horas
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: HistorialLicHorasDatatable.new(view_context, { query: horas_persona(@dni)}) }
    end

  end


  def historial_cargos
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: HistorialLicCargosDatatable.new(view_context, { query: cargos_persona(@dni)}) }
    end
    
  end

  def historial_cargos_no_docentes
    @dni=params[:dni]
    respond_to do |format|
      format.json { render json: HistorialLicCargosNoDocentesDatatable.new(view_context, { query: cargos_no_docentes_persona(@dni)}) }
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
    
        # lista de arituculos que generan traslados definitivos
    listaArtTrasladosDef =  ["394","395"]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378"]
    con_formulario = params['con_formulario'].to_i
    con_certificado = params['con_certificado'].to_i

     altbahora = AltasBajasHora.where(id: params['id_horas']).first
     descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
     @oficina = Establecimiento.where(id: altbahora.establecimiento_id).first
     @persona = Persona.where(id: altbahora.persona_id).first
     nro_documento = @persona.nro_documento
     userLic = current_user.id
     ultima_lic = Licencium.where(cargo_id: params['id_horas']).last
     art_id = Articulo.where(id: params['articulo']).first.id
     licencias_anuales = [241,289]
     @oficina = Establecimiento.where(id: altbahora.establecimiento_id).first
     nro_oficina = @oficina.codigo_jurisdiccional

    if licencias_anuales.include? art_id and params[:fecha_anio_lic] == nil
      msg = "Complete el año de la licencia"
      render json: msg.to_json 
    elsif  (altbahora.turno == nil or altbahora.turno == "")
      msg = "El cargo docente no tiene turno asignado"
      render json: msg.to_json 
    else 
      if listaArtTrasladosTrans.include? params[:articulo] and altbahora.secuencia != 1000
          if params[:destino].to_i > 0
            @oficina = Establecimiento.where(id: params[:destino]).first
            nro_oficina = @oficina.codigo_jurisdiccional
          else
            @oficina = Establecimiento.where(id: altbahora.establecimiento_id).first
            nro_oficina = @oficina.codigo_jurisdiccional
          end
          
          @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario , altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones] , nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          if @licencia.save && AltasBajasHora.create(establecimiento_id: @oficina.id, persona_id: altbahora.persona_id, secuencia: 1000, horas: altbahora.horas, plan_id: altbahora.plan_id, materium_id: altbahora.materium_id, fecha_alta: altbahora.fecha_alta, anio: altbahora.anio, division: altbahora.division, fecha_baja: altbahora.fecha_baja, ciclo_carrera: altbahora.ciclo_carrera, situacion_revista: altbahora.situacion_revista, turno: altbahora.turno, estado: 'REU', obs_lic: descripcion_articulo)
            render json: 0
          else
            render json: @licencia.errors.full_messages.first.to_json
          end

      # ----------------traslados definitivo
      elsif listaArtTrasladosDef.include? params[:articulo] and altbahora.secuencia != 1000
        
        @oficinaActual = Establecimiento.where(id: altbahora.establecimiento_id).first
        @oficina = Establecimiento.where(id: params[:destino]).first
        if params[:destino].to_i > 0 and (@oficinaActual != @oficina) 
          if  AltasBajasHora.find(params['id_horas']).update(establecimiento_id: @oficina.id, estado: 'REU')
              Traslado.create!(:alta_baja_hora_id => altbahora.id, user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
             render json: 0
          end
        else
            render json: "no se puede realizar el traslado, debe elegir otro establecimiento".to_json
        end 
        #---------------licencias comunes
      elsif (listaArtTrasladosDef.include? params[:articulo] and altbahora.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and altbahora.secuencia == 1000)
          render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
      else 
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario ,altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save
                 render json: 0
            else
                 render json: @licencia.errors.full_messages.first.to_json
            end
        end
      end
    end


   def guardar_licencia_horas2
    prestador_3 = params[:prestador_2]
    # lista de arituculos que generan traslados definitivos
    listaArtTrasladosDef =  ["394","395",  394, 395]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378", 352, 353, 354,  355, 356 , 357, 358, 359, 360, 378]

    @licencia_anterior= Licencium.where(altas_bajas_hora_id: params['id_horas'], vigente: 'vigente').last
    altbahora = AltasBajasHora.where(id: params['id_horas']).first 
    @persona = Persona.where(id: altbahora.persona_id).first
    nro_documento = @persona.nro_documento
    userLic = current_user.id
    @oficina = Establecimiento.where(id: altbahora.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
    ultima_lic = Licencium.where(cargo_id: params['id_horas']).last
    art_id = Articulo.where(id: params['articulo']).first.id
    licencias_anuales = [241,289]
    con_formulario = params['con_formulario'].to_i
    con_certificado = params['con_certificado'].to_i

    if licencias_anuales.include? art_id and params[:fecha_anio_lic] == nil
      msg = "Complete el año de la licencia"
      render json: msg.to_json 
    elsif (altbahora.turno == nil or altbahora.turno == "")
      msg = "Las horas cátedra no tiene turno asignado"
      render json: msg.to_json 
    #SI POSEE TURNO VERIFICO LO DEMÀS
    else 
      
      # ----------------reubicaciones y traslados transitorio
      if listaArtTrasladosTrans.include? params[:articulo] and altbahora.secuencia != 1000
          if params[:destino].to_i > 0
            @oficina = Establecimiento.where(id: params[:destino]).first
            nro_oficina = @oficina.codigo_jurisdiccional
          else
            @oficina = Establecimiento.where(id: altbahora.establecimiento_id).first
            nro_oficina = @oficina.codigo_jurisdiccional
          end
         #BUSCO LA LICENCIA ANTERIOR Y VERIFICO SI TIENE FECHA HASTA
         
          if @licencia_anterior.fecha_hasta == nil
              if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
                fecha = params[:fecha_inicio].to_date - 1
                #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
                @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
                
                descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
                if (AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil)
                  altbahora1000 = AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                  altbahora1000.update!(:estado => "BAJ") 
                end
                #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL
                @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic,  oficina: nro_oficina)
                
                if @licencia.save && AltasBajasHora.create!(establecimiento_id: @oficina.id, persona_id: altbahora.persona_id, secuencia: 1000, horas: altbahora.horas, plan_id: altbahora.plan_id, materium_id: altbahora.materium_id, fecha_alta: altbahora.fecha_alta, anio: altbahora.anio, division: altbahora.division, fecha_baja: altbahora.fecha_baja, ciclo_carrera: altbahora.ciclo_carrera, situacion_revista: altbahora.situacion_revista, turno: altbahora.turno, estado: 'REU', obs_lic: descripcion_articulo)
                  render json: 0
                else
                  render json: @licencia.errors.full_messages.first.to_json
                end
              else
                render json: "no se puede crear la licencia, error de fechas ".to_json
              end
          elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
              @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
              
              descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
              if (AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil)
                altbahora1000 = AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                altbahora1000.update!(:estado => "BAJ") 
              end
              #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL
              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic,  oficina: nro_oficina)
              if @licencia.save &&  @licencia.save && AltasBajasHora.create!(establecimiento_id: @oficina.id, persona_id: altbahora.persona_id, secuencia: 1000, horas: altbahora.horas, plan_id: altbahora.plan_id, materium_id: altbahora.materium_id, fecha_alta: altbahora.fecha_alta, anio: altbahora.anio, division: altbahora.division, fecha_baja: altbahora.fecha_baja, ciclo_carrera: altbahora.ciclo_carrera, situacion_revista: altbahora.situacion_revista, turno: altbahora.turno, estado: 'REU', obs_lic: descripcion_articulo)
                render json: 0
              else
                render json: @licencia.errors.full_messages.first.to_json
              end
          elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
            render json: "no se puede crear la licencia, error de fechas ".to_json
          end 

        

      # ----------------traslados definitivo
      elsif listaArtTrasladosDef.include? params[:articulo] and altbahora.secuencia != 1000
          @oficinaActual = Establecimiento.where(id: altbahora.establecimiento_id).first
          @oficina = Establecimiento.where(id: params[:destino]).first
          if params[:destino].to_i > 0 and (@oficinaActual != @oficina) 
            #BUSCO EL CARGO Y LE CAMBIO LA OFICINA
            #LUEGO BUSCO LA LCIENCIA ANTERIOR Y LA CIERRO
            if  AltasBajasHora.find(params['id_horas']).update(establecimiento_id: @oficina.id, estado: 'REU')
                Traslado.create!(:alta_baja_hora_id => altbahora.id, user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
                if @licencia_anterior.fecha_hasta == nil
                    if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
                      fecha = params[:fecha_inicio].to_date - 1
                      #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
                      @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
                      render json: 0
                    else
                      render json: "no se puede crear la licencia, error de fechas ".to_json
                    end
                elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
                    @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
                    render json: 0
                elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
                    render json: "no se puede crear la licencia, error de fechas ".to_json
                end 
            end   
            else
              render json: "no se puede realizar el traslado, debe elegir otro establecimiento".to_json
            end  


      #---------------LICENCIAS COMUNES 
      elsif (listaArtTrasladosDef.include? params[:articulo] and altbahora.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and altbahora.secuencia == 1000)
          render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
      else 

          if @licencia_anterior.fecha_hasta == nil
              if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
                fecha = params[:fecha_inicio].to_date - 1
                if listaArtTrasladosTrans.include? @licencia_anterior.articulo_id
                    descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
                    altbahora1000 = AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                    altbahora1000.update!(:estado => "BAJ")                                                                                                                                       
                end 
                @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
                if @licencia.save
                  @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
                  render json: 0
                end
              else
                render json: "no se puede crear la licencia, error de fechas ".to_json
              end
          elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
                if listaArtTrasladosTrans.include? @licencia_anterior.articulo_id
                    descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
                    altbahora1000 = AltasBajasHora.where(:persona_id => altbahora.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                    altbahora1000.update!(:estado => "BAJ")                                                                                                                                       
                end 
              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, altas_bajas_hora_id: params[:id_horas], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
              if @licencia.save
                  @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
                  render json: 0
              end
          elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
            render json: "no se puede crear la licencia, error de fechas ".to_json
          end 
        end
      end
    end

  def poner_establecimientos
    
    lic = Licencium.where(:oficina => nil)

    lic.each do |e| 
      if e.altas_bajas_hora_id != nil
        if AltasBajasHora.where(:id => e.altas_bajas_hora_id).first != nil
          ofi_id = AltasBajasHora.where(:id => e.altas_bajas_hora_id).first.establecimiento_id
          e.oficina = Establecimiento.where(:id => ofi_id).first.codigo_jurisdiccional
          e.save
        end
      elsif e.cargo_id != nil
        if  Cargo.where(:id => e.cargo_id).first != nil
          ofi_id = Cargo.where(:id => e.cargo_id).first.establecimiento_id
          e.oficina = Establecimiento.where(:id => ofi_id).first.codigo_jurisdiccional
          e.save
        end
      elsif e.cargo_no_docente_id != nil
        if CargoNoDocente.where(:id => e.cargo_no_docente_id).first != nil
          ofi_id = CargoNoDocente.where(:id => e.cargo_no_docente_id).first.establecimiento_id
          e.oficina = Establecimiento.where(:id => ofi_id).first.codigo_jurisdiccional
          e.save
        end
      end
    end

  end


  def guardar_licencia_cargos

    # lista de arituculos que generan traslados definitivos
    listaArtTrasladosDef =  ["394","395"]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378"]
    cargo = Cargo.where(id: params['id_cargos']).first
    secuencia= cargo.secuencia
    descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
    @persona = Persona.where(id: cargo.persona_id).first
    nro_documento = @persona.nro_documento
    userLic = current_user.id
    @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    ultima_lic = Licencium.where(cargo_id: params['id_cargos']).last
    art_id = Articulo.where(id: params['articulo']).first.id
    con_formulario = params['con_formulario'].to_i
    con_certificado = params['con_certificado'].to_i

    licencias_anuales = [241,289]
    
    if licencias_anuales.include? art_id and params[:fecha_anio_lic_1] == nil
      msg = "Complete el año de la licencia"
      render json: msg.to_json 

    elsif (cargo.turno == nil or cargo.turno == "")
      msg = "El cargo docente no tiene turno asignado"
      render json: msg.to_json 
   
    else 
      # ----------------reubicaciones y traslados transitorio
      if listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia != 1000
          if params[:destino].to_i > 0
            @oficina = Establecimiento.where(id: params[:destino]).first
            nro_oficina = @oficina.codigo_jurisdiccional
          else
            @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
            nro_oficina = @oficina.codigo_jurisdiccional
          end
          @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          if @licencia.save && Cargo.create!(establecimiento_id: @oficina.id, persona_id: cargo.persona_id, cargo: cargo.cargo, secuencia: 1000, fecha_alta: cargo.fecha_alta, anio:0, division: 0, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista, turno: cargo.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
            render json: 0
          else
            render json: @licencia.errors.full_messages.first.to_json
          end

      # ----------------traslados definitivo
      elsif listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia != 1000
        @oficinaActual = Establecimiento.where(id: cargo.establecimiento_id).first
        @oficina = Establecimiento.where(id: params[:destino]).first
        
        if params[:destino].to_i > 0 and (@oficinaActual != @oficina) 
          if  Cargo.find(params['id_cargos']).update(establecimiento_id: @oficina.id, estado: 'REU')
              Traslado.create!(:cargo_id => cargo.id, user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
             render json: 0
          end
        else
            render json: "no se puede realizar el traslado, debe elegir otro establecimiento".to_json
        end 
        #---------------licencias comunes
      elsif (listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia == 1000)
          render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
      else 
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_1], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save
                 render json: 0
            else
                 render json: @licencia.errors.full_messages.first.to_json
            end
        end
      end
    end








  def guardar_licencia_cargos2

  # lista de arituculos que generan traslados definitivos
  listaArtTrasladosDef =  ["394","395", 394, 395]
  # lista de arituculos que generan traslados transitorios
  listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378", 352, 353, 354,  355, 356 , 357, 358, 359, 360, 378]

  prestador_3 = params[:prestador_3]  
  secuencia=Cargo.where(id: params['id_cargos']).first.secuencia
  descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
  @licencia_anterior= Licencium.where(cargo_id: params['id_cargos'], vigente: 'vigente').last
  cargo = Cargo.where(id: params['id_cargos']).first 
  persona = Persona.where(id: cargo.persona_id).first
  nro_documento = persona.nro_documento
  userLic = current_user.id
  ultima_lic = Licencium.where(cargo_id: params['id_cargos']).last
  art_id = Articulo.where(id: params['articulo']).first.id
  licencias_anuales = [241,289]
  @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
  nro_oficina = @oficina.codigo_jurisdiccional
  con_formulario = params['con_formulario'].to_i
  con_certificado = params['con_certificado'].to_i

  if licencias_anuales.include? art_id and params[:fecha_anio_lic_7] == nil
    msg = "Complete el año de la licencia"
    render json: msg.to_json 
  elsif (cargo.turno == nil or cargo.turno == "")
    msg = "El cargo docente no tiene turno asignado"
    render json: msg.to_json 
  #SI POSEE TURNO VERIFICO LO DEMÀS
  else 
    
    # ----------------reubicaciones y traslados transitorio
    if listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia != 1000
        if params[:destino].to_i > 0
          @oficina = Establecimiento.where(id: params[:destino]).first
          nro_oficina = @oficina.codigo_jurisdiccional
        else
          @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
          nro_oficina = @oficina.codigo_jurisdiccional
        end
       #BUSCO LA LICENCIA ANTERIOR Y VERIFICO SI TIENE FECHA HASTA
        if @licencia_anterior.fecha_hasta == nil
            if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
              fecha = params[:fecha_inicio].to_date - 1
              #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
              @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
              #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL

              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
              
              descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
              if Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil
                cargo1000 = Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                cargo1000.update!(:estado => "BAJ") 
              end


              if @licencia.save && Cargo.create!(establecimiento_id: @oficina.id, persona_id: cargo.persona_id, cargo: cargo.cargo, secuencia: 1000, fecha_alta: cargo.fecha_alta, anio:0, division: 0, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista, turno: cargo.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
                render json: 0
              else
                render json: @licencia.errors.full_messages.first.to_json
              end
            else
              render json: "no se puede crear la licencia, error de fechas ".to_json
            end
        elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
            @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
            #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL

            descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion

            if Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil
              cargo1000 = Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
              cargo1000.update!(:estado => "BAJ") 
            end
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save && Cargo.create!(establecimiento_id: @oficina.id, persona_id: cargo.persona_id, cargo: cargo.cargo, secuencia: 1000, fecha_alta: cargo.fecha_alta, anio:0, division: 0, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista, turno: cargo.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
              render json: 0
            else
              render json: @licencia.errors.full_messages.first.to_json
            end
        elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
          render json: "no se puede crear la licencia, error de fechas ".to_json
        end 

      

    # ----------------traslados definitivo
    elsif listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia != 1000
        @oficinaActual = Establecimiento.where(id: cargo.establecimiento_id).first
        @oficina = Establecimiento.where(id: params[:destino]).first
        if params[:destino].to_i > 0 and (@oficinaActual != @oficina) 
          #BUSCO EL CARGO Y LE CAMBIO LA OFICINA
          #LUEGO BUSCO LA LCIENCIA ANTERIOR Y LA CIERRO
          if  Cargo.find(params['id_cargos']).update(establecimiento_id: @oficina.id, estado: 'REU')
              Traslado.create!(:cargo_id => cargo.id, user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
              if @licencia_anterior.fecha_hasta == nil
                  if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
                    fecha = params[:fecha_inicio].to_date - 1
                    #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
                    @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
                    render json: 0
                  else
                    render json: "no se puede crear la licencia, error de fechas ".to_json
                  end
              elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
                  @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
                  render json: 0
              elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
                  render json: "no se puede crear la licencia, error de fechas ".to_json
              end 
          end   
          else
            render json: "no se puede realizar el traslado, debe elegir otro establecimiento".to_json
          end  


    #---------------LICENCIAS COMUNES 
    elsif (listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia == 1000)
        render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
    else 
        if listaArtTrasladosTrans.include? @licencia_anterior.articulo_id
          descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
          cargo1000 = Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
          cargo1000.update!(:estado => "BAJ") 
          @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )                                                                                                                                      
        end 
        if @licencia_anterior.fecha_hasta == nil
            if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
              fecha = params[:fecha_inicio].to_date - 1
              @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
              if @licencia.save
                render json: 0
              end
            else
              render json: "no se puede crear la licencia, error de fechas ".to_json
            end
        elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
            @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_id: params[:id_cargos], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save
                render json: 0
            end
        elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
          render json: "no se puede crear la licencia, error de fechas ".to_json
        end 
      end
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
    userLic = current_user.id
    @oficina = Establecimiento.where(id: cargonds.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    ultima_lic = Licencium.where(cargo_id: params['id_cargos_no_docentes']).last
    con_formulario = params['con_formulario'].to_i
    con_certificado = params['con_certificado'].to_i



    # lista de arituculos que generan traslados definitivos
    listaArtTrasladosDef =  ["394","395"]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378"]

    art_id = Articulo.where(id: params['articulo']).first.id
    licencias_anuales = [241,289]
    

    if licencias_anuales.include? art_id and params[:fecha_anio_lic_2] == nil
      msg = "Complete el año de la licencia"
      render json: msg.to_json 
    elsif (turnocnds == nil or turnocnds == "")
      msg = "El cargo auxiliar no tiene turno asignado"
      render json: msg.to_json 
   
    else 
      # ----------------reubicaciones y traslados transitorio
      if listaArtTrasladosTrans.include? params[:articulo] and cargonds.secuencia != 1000
          if params[:destino].to_i > 0
            @oficina = Establecimiento.where(id: params[:destino]).first
            nro_oficina = @oficina.codigo_jurisdiccional
          else
            @oficina = Establecimiento.where(id: cargonds.establecimiento_id).first
            nro_oficina = @oficina.codigo_jurisdiccional
          end
          @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2], destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          if @licencia.save && CargoNoDocente.create!(establecimiento_id: @oficina.id, persona_id: cargonds.persona_id, cargo: cargonds.cargo, secuencia: 1000, fecha_alta: cargonds.fecha_alta, fecha_baja: cargonds.fecha_baja, situacion_revista: cargonds.situacion_revista, turno: cargonds.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
            render json: 0
          else
            render json: @licencia.errors.full_messages.first.to_json
          end
      # ----------------traslados definitivo
      elsif listaArtTrasladosDef.include? params[:articulo] and cargonds.secuencia != 1000
        if params[:destino].to_i > 0
            @oficina = Establecimiento.where(id: params[:destino]).first
            nro_oficina = @oficina.codigo_jurisdiccional
        else
            @oficina = Establecimiento.where(id: cargonds.establecimiento_id).first
            nro_oficina = @oficina.codigo_jurisdiccional
        end

        if  CargoNoDocente.find(params['id_cargos_no_docentes']).update(establecimiento_id: @oficina.id, estado: 'REU')
            Traslado.create!(:cargo_no_docente_id => params['id_cargos_no_docentes'], user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
           render json: 0
        else
           render json: "no se puede realizar el traslado".to_json
        end 

      #---------------licencias comunes
      elsif (listaArtTrasladosDef.include? params[:articulo] and cargonds.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and cargonds.secuencia == 1000)
        render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
      else 
          @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_2], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          if @licencia.save
               render json: 0
          else
               render json: @licencia.errors.full_messages.first.to_json
          end
      end
    end
  end


  def guardar_licencia_cargos_no_docentes2

    listaArtTrasladosDef =  ["394","395", 394, 395]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = ["352","353", "354", "355", "356", "357", "358", "359", "360", "378", 352, 353, 354,  355, 356 , 357, 358, 359, 360, 378]

    
    @no_guarda = true
    prestador_3 = params[:prestador_4]  
    descripcion_articulo = Articulo.where(id: params['articulo']).first.descripcion
    @licencia_anterior= Licencium.where(cargo_no_docente_id: params['id_cargos_no_docentes'], vigente: 'vigente').last
    cargo = CargoNoDocente.where(id: params['id_cargos_no_docentes']).first 
    persona = Persona.where(id: cargo.persona_id).first
    nro_documento = persona.nro_documento
    userLic = current_user.id
    ultima_lic = Licencium.where(cargo_no_docente_id: params['id_cargos_no_docentes']).last
    @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
    nro_oficina = @oficina.codigo_jurisdiccional
    con_formulario = params['con_formulario'].to_i
    con_certificado = params['con_certificado'].to_i

    art_id = Articulo.where(id: params['articulo']).first.id
    licencias_anuales = [241,289]

    if licencias_anuales.include? art_id and params[:fecha_anio_lic_7] == nil
      msg = "Complete el año de la licencia"
      render json: msg.to_json 
    elsif (cargo.turno == nil or cargo.turno == "")
      msg = "El cargo docente auxiliar no tiene turno asignado"
      render json: msg.to_json 
    #SI POSEE TURNO VERIFICO LO DEMÀS
  
    else 


    # ----------------reubicaciones y traslados transitorio
    if listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia != 1000
        if params[:destino].to_i > 0
          @oficina = Establecimiento.where(id: params[:destino]).first
          nro_oficina = @oficina.codigo_jurisdiccional
        else
          @oficina = Establecimiento.where(id: cargo.establecimiento_id).first
          nro_oficina = @oficina.codigo_jurisdiccional
        end
       #BUSCO LA LICENCIA ANTERIOR Y VERIFICO SI TIENE FECHA HASTA
        if @licencia_anterior.fecha_hasta == nil
            if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
              fecha = params[:fecha_inicio].to_date - 1
              #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
              @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
              #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL

              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
              
              descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
              if CargoNoDocente.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil
                cargo1000 = CargoNoDocente.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
                cargo1000.update!(:estado => "BAJ") 
              end


              if @licencia.save && CargoNoDocente.create!(establecimiento_id: @oficina.id, persona_id: cargo.persona_id, cargo: cargo.cargo, secuencia: 1000, fecha_alta: cargo.fecha_alta, fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista, turno: cargo.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
                render json: 0
              else
                render json: @licencia.errors.full_messages.first.to_json
              end
            else
              render json: "no se puede crear la licencia, error de fechas ".to_json
            end
        elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
            @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
            #CREO UNA LICENCIA PARA EL REGISTRO ACTUAL

            descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion

            if CargoNoDocente.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first != nil
              cargo1000 = CargoNoDocente.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
              cargo1000.update!(:estado => "BAJ") 
            end
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params['id_cargos_no_docentes'], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", destino: @oficina.id, observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save && CargoNoDocente.create!(establecimiento_id: @oficina.id, persona_id: cargo.persona_id, cargo: cargo.cargo, secuencia: 1000, fecha_alta: cargo.fecha_alta,  fecha_baja: cargo.fecha_baja, situacion_revista: cargo.situacion_revista, turno: cargo.turno,   estado: 'REU' , obs_lic: descripcion_articulo)
              render json: 0
            else
              render json: @licencia.errors.full_messages.first.to_json
            end
        elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
          render json: "no se puede crear la licencia, error de fechas ".to_json
        end 

      

    # ----------------traslados definitivo
    elsif listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia != 1000
        @oficinaActual = Establecimiento.where(id: cargo.establecimiento_id).first
        @oficina = Establecimiento.where(id: params[:destino]).first
        if params[:destino].to_i > 0 and (@oficinaActual != @oficina) 
          #BUSCO EL CARGO Y LE CAMBIO LA OFICINA
          #LUEGO BUSCO LA LCIENCIA ANTERIOR Y LA CIERRO
          if  CargoNoDocente.find(params['id_cargos_no_docentes']).update(establecimiento_id: @oficina.id, estado: 'REU')
              Traslado.create!(:cargo_no_docente_id => params['id_cargos_no_docentes'], user_id: current_user.id, fecha_cambio_oficina: params[:fecha_inicio])
              if @licencia_anterior.fecha_hasta == nil
                  if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
                    fecha = params[:fecha_inicio].to_date - 1
                    #ACTUALIZO LA LICENCIA CON FECHA FIN, CON LA FECHA INICIO -1
                    @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
                    render json: 0
                  else
                    render json: "no se puede crear la licencia, error de fechas ".to_json
                  end
              elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
                  @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
                  render json: 0
              elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
                  render json: "no se puede crear la licencia, error de fechas ".to_json
              end 
          end   
          else
            render json: "no se puede realizar el traslado, debe elegir otro establecimiento".to_json
          end  


    #---------------LICENCIAS COMUNES 
    elsif (listaArtTrasladosDef.include? params[:articulo] and cargo.secuencia == 1000) or (listaArtTrasladosTrans.include? params[:articulo] and cargo.secuencia == 1000)
        render json: "no se puede realizar el traslado, ya se encuentra con traslado".to_json
    else
        
        if listaArtTrasladosTrans.include? @licencia_anterior.articulo_id
          descripcion_articulo2 = Articulo.where(id: @licencia_anterior.articulo_id).first.descripcion
          cargo1000 = CargoNoDocente.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo2 ).where.not(estado: "BAJ").first
          cargo1000.update!(:estado => "BAJ") 
          @licencia = Licencium.new(cargo_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
          @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )                                                                                                                                      
        end 
        if @licencia_anterior.fecha_hasta == nil
            if params[:fecha_inicio].to_date > @licencia_anterior.fecha_desde.to_date
              fecha = params[:fecha_inicio].to_date - 1
              @licencia_anterior.update!(vigente: 'Finalizada', fecha_hasta:  fecha, por_continua: 1, prestador_id: prestador_3 )
              @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
              if @licencia.save
                render json: 0
              end
            else
              render json: "no se puede crear la licencia, error de fechas ".to_json
            end
        elsif params[:fecha_inicio].to_date > @licencia_anterior.fecha_hasta.to_date
            @licencia_anterior.update!(vigente: 'Finalizada',  por_continua: 1, prestador_id: prestador_3)
            @licencia = Licencium.new(con_certificado: con_certificado, con_formulario: con_formulario, cargo_no_docente_id: params[:id_cargos_no_docentes], fecha_desde: params[:fecha_inicio], fecha_hasta: params[:fecha_fin], articulo_id: params[:articulo], vigente: "Vigente", anio_lic: params[:fecha_anio_lic_7], observaciones: params[:observaciones], nro_documento: nro_documento, user_id: userLic, oficina: nro_oficina)
            if @licencia.save
                render json: 0
            end
        elsif params[:fecha_inicio].to_date <= @licencia_anterior.fecha_hasta.to_date
          render json: "no se puede crear la licencia, error de fechas ".to_json
        end 
      end
    end
  end






  def guardar_licencia_cargos_no_docentes2_obs
  end



  def guardar_licencia_final

     # lista de arituculos que generan traslados definitivos
    listaArtTrasladosDef =  [394,395]
    # lista de arituculos que generan traslados transitorios
    listaArtTrasladosTrans = [352,353, 354, 355, 356, 357, 358, 359, 360, 378]

    @licencia = Licencium.where(id: params[:id_lic]).first
    baja = params[:por_baja] == "1"
    prestador = params[:prestador]
    observaciones = params[:observaciones]
    descripcion_articulo = Articulo.where(id: @licencia.articulo_id).first.descripcion
    con_formulario = params[:con_formulario].to_i
    con_certificado = params[:con_certificado].to_i
    msg = ""
    msg1 = ""
    msg2 = "  o  "
    c = ""
    
    if params[:fecha_inicio].to_date > params[:fecha_fin].to_date
        msg = "Error de fechas"
    end
     


    #eliminar el cargo no docente y cambiar el estado al cargo origen 
    #verificar que sea cargo no docente.
    #buscar cargo no docente con secuencia 1000

    #----------  BUSCAR CARGO AUXILIAR QUE POSEE LA SECUNCIA 1000 y la descripcion del articulo que genero la secuencia 1000 PARA ELIMINARLA                                                                                                                                                                                                                                 

    if @licencia.cargo_no_docente_id != nil 
      if (listaArtTrasladosTrans.include?  @licencia.articulo_id )
        cargoNoDoc = CargoNoDocente.where(:id => @licencia.cargo_no_docente_id).first
        cargoNoDoc1000 = CargoNoDocente.where(:persona_id => cargoNoDoc.persona_id, obs_lic: descripcion_articulo ,:secuencia => 1000).where.not(estado: "BAJ").first
        cargoNoDoc1000.update!(:estado => "BAJ")
        cargoNoDoc.update!(:estado => "ALT")
      end
    end
    #----------  BUSCAR CARGO DOCENTE QUE POSEE LA SECUNCIA 1000 y la descripcion del articulo que genero la secuencia 1000 PARA ELIMINARLA     

    
    if @licencia.cargo_id != nil 
      if (listaArtTrasladosTrans.include?  @licencia.articulo_id )
        cargo = Cargo.where(:id => @licencia.cargo_id).first
        cargo1000 = Cargo.where(:persona_id => cargo.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo ).where.not(estado: "BAJ").first
        cargo1000.update!(:estado => "BAJ")
        cargo.update!(:estado => "ALT")
      end
    end


    if @licencia.altas_bajas_hora_id != nil 
      if (listaArtTrasladosTrans.include?  @licencia.articulo_id )
        horas = AltasBajasHora.where(:id => @licencia.altas_bajas_hora_id).first
        horas1000 = AltasBajasHora.where(:persona_id => horas.persona_id, :secuencia => 1000, obs_lic: descripcion_articulo ).where.not(estado: "BAJ").first
        horas1000.update!(:estado => "BAJ")
        horas.update!(:estado => "ALT")
      end
    end
    
    if msg == "" and !@licencia.update(con_certificado: con_certificado, con_formulario: con_formulario , fecha_hasta: params[:fecha_fin], vigente: "Finalizada", por_baja: baja, prestador_id: prestador, observaciones: observaciones)
      msg1  = "  No se puede finalizar la licencia. Posee suplente. O no corresponde la situación de revista"
    end

    if msg != "" and msg1 != ""
      c = msg + msg2 + msg1
    elsif msg != "" and  msg1 == ""
      c = msg
    elsif msg == "" and  msg1 != ""
      c = msg1
    end

    render json: c.to_json
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

  def guardar_licencia_obs
    
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
    
    @licencia_alta = licencias.where("fecha_cheq_cargada >= '" + fecha_i + "' and fecha_cheq_cargada <= '"+ fecha_f + "'and user_cheq_cargada_id ='" + current_user.id.to_s + "'")
    @licencia_fin = licencias.where("fecha_cheq_finalizada >= '" + fecha_i + "' and fecha_cheq_finalizada <= '"+ fecha_f + "'and user_cheq_finalizada_id ='" + current_user.id.to_s + "'" )
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

  def sin_certificado
    @mes = params["mes"] 
    @anio = params["anio"]

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
    @licencias_sin_cert = Licencium.select('licencia.*').from('licencia, establecimientos, articulos').where(' YEAR(licencia.fecha_desde) = ' + @anio + ' and MONTH(licencia.fecha_desde) = '+ @mes +' and licencia.fecha_desde >= "2018-09-01" and establecimientos.codigo_jurisdiccional = licencia.oficina and establecimientos.sede = 1 and (licencia.observaciones = "" or licencia.observaciones = null or licencia.con_certificado = null or licencia.con_certificado = 0 ) and (licencia.articulo_id = articulos.id) and ( articulos.medico = 1) and licencia.vigente != "Cancelada"')
    
    respond_to do |format|
    format.pdf do
      render :pdf => 'sin_certificado', 
      :template => 'licencia/sin_certificado_pdf.html.erb',
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
