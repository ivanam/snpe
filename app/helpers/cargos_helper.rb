module CargosHelper
  def cargos_nuevos_permitidos(mindate, maxdate)
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento])
    @cargos_ids = []
    @cargos.each do |c|
      if c.estado_actual == "Ingresado" || c.estado_actual == "Cancelado"
        @cargos_ids << c.id
      end
    end
    #AltasBajasHoraEstado.where()
    return Cargo.where(:id => @cargos_ids).includes(:persona)
  end

  def cargos_notificados_permitidos(mindate, maxdate)
    @cargos_ids = []
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento])
    @cargos.each do |c|
      if c.estado_actual == "Notificado"
        @cargos_ids << c.id
      end
    end
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
    @cargos.each do |c|
      if c.estado_actual == "Chequeado" || c.estado_actual == "Impreso" || c.estado_actual == "Cobrado"
        @cargos_ids << c.id
      end
    end
    return Cargo.where(:id => @cargos_ids).includes(:persona)
  end

  def cargos_novedades_permitidas(mindate, maxdate)
    @cargos_ids = []
    if current_user.role? :delegacion
      if (current_user.region == '2')
      @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "II"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC') 
      end
      if (current_user.region == '6')
      @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "VI"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC') 
      end
    end

    if (current_user.role? :escuela) || (current_user.role? :sadmin) || (current_user.role? :personal) 
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").order('fecha_baja DESC') 
    end

    @cargos.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Chequeado_Baja"
        @cargos_ids << a.id
      end
    end

    if current_user.role? :delegacion
      if (current_user.region == '2')
       @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "II"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC') 
      end
      if (current_user.region == '6')
       @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "VI"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC') 
      end
    end

    if (current_user.role? :escuela) || (current_user.role? :sadmin) || (current_user.role? :personal)
       @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_time.iso8601 + "' and fecha_alta <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").order('fecha_baja DESC') 
    end
    #@cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
    @cargos.each do |a|
      if a.estado_actual == "Impreso" || a.estado_actual == "Cobrado"
        @cargos_ids << a.id
      end
    end
    return Cargo.where(:id => @cargos_ids).includes(:persona, :establecimiento)
  end

  def cargos_modificacion
       return Cargo.where(:establecimiento_id => session[:establecimiento]).where.not(:estado => "LIC P/BAJ").includes(:establecimiento, :persona)
  end



  def cargo_bajas_efectivas(mindate, maxdate)
    @cargos_ids = []
    if current_user.role? :delegacion
      if (current_user.region == '2')  
       @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(:fecha_baja => nil).where("( fecha_baja >= '" + mindate.to_time.iso8601 + "' and fecha_baja <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "II"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC')
      end
      if (current_user.region == '6')
      @cargos = Cargo.select('cargos.*').from('cargos, establecimientos, localidads, regions').where('cargos.establecimiento_id = establecimientos.id AND establecimientos.localidad_id = localidads.id AND localidads.region_id = regions.id ').where.not(:fecha_baja => nil).where("( fecha_baja >= '" + mindate.to_time.iso8601 + "' and fecha_baja <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('regions.nombre = "VI"').where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC')
      end
    end

    if (current_user.role? :escuela) || (current_user.role? :sadmin) || (current_user.role? :personal)
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").where("( fecha_baja >= '" + mindate.to_time.iso8601 + "' and fecha_baja <= '" + maxdate.to_time.iso8601 + "' ) or ( cargos.updated_at >= '" + mindate.to_time.iso8601 + "' and cargos.updated_at <= '" + maxdate.to_time.iso8601 + "' )").where('fecha_baja != "" or  fecha_baja is not NULL').order('fecha_baja DESC')
    end
   #@cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").where("( fecha_baja >= '" + mindate.to_time.iso8601 + "' and fecha_baja <= '" + maxdate.to_time.iso8601 + "' ) or ( updated_at >= '" + mindate.to_time.iso8601 + "' and updated_at <= '" + maxdate.to_time.iso8601 + "' )")
 
    @cargos.each do |c|
      if c.estado_actual == "Notificado_Baja" || c.estado_actual == "Impreso" || c.estado_actual == "Chequeado_Baja"
        @cargos_ids << c.id
      end
    end
    return Cargo.where(:id => @cargos_ids).includes(:establecimiento, :persona)
  end

   def cargos_bajas_permitidas
    establecimiento = session[:establecimiento]
    if current_user.role? :licencia
      establecimiento = current_user.establecimientos_users.map(&:establecimiento_id)
    end
    return Cargo.where(:establecimiento_id => establecimiento).where.not(:estado => "LIC P/BAJ").where("fecha_baja is null or fecha_baja = '0000-00-00'").includes(:establecimiento, :persona)
  end

end
