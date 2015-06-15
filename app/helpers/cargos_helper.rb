module CargosHelper
  def cargos_nuevos_permitidos(mindate, maxdate)
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
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
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    @cargos_ids = []
    @cargos.each do |c|
      if c.estado_actual == "Notificado" || c.estado_actual == "Chequeado" || c.estado_actual == "Impreso"
        @cargos_ids << c.id
      end
    end
    #AltasBajasHoraEstado.where()
    return Cargo.where(:id => @cargos_ids).includes(:persona)
  end

  def cargos_novedades_permitidas(mindate, maxdate)
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    @cargos_ids = []
    @cargos.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
        @cargos_ids << a.id
      end
    end
    @cargos = Cargo.where(:establecimiento_id => session[:establecimiento]).where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate)
    @cargos.each do |a|
      if a.estado_actual == "Impreso" || a.estado_actual == "Chequeado_Baja"
        @cargos_ids << a.id
      end
    end
    return Cargo.where(:id => @cargos_ids)
  end
end