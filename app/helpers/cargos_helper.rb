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
    debugger
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento])
    @cargos_ids = []
    @cargos.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Chequeado_Baja"
        @cargos_ids << a.id
      end
    end
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
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
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate).where('updated_at >= ?', mindate).where('updated_at <= ?', maxdate)
    @cargos_ids = []
    @cargos.each do |c|
      if c.estado_actual == "Chequeado_Baja" || c.estado_actual == "Impreso" || c.estado_actual == "Notificado_Baja"
        @cargos_ids << c.id
      end
    end
    return Cargo.where(:id => @cargos_ids).includes(:establecimiento, :persona)
  end

   def cargos_bajas_permitidas
    return Cargo.where(:establecimiento_id => session[:establecimiento]).where.not(:estado => "LIC P/BAJ").where("fecha_baja is null or fecha_baja = '0000-00-00'").includes(:establecimiento, :persona)
  end

end
