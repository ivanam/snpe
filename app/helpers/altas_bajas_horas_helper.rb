module AltasBajasHorasHelper
  def altas_bajas_horas_permitidas_altas(mindate, maxdate)
    debugger
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Ingresado" || a.estado_actual == "Cancelado"
        @altasbajashoras_ids << a.id
      end
    end
    #AltasBajasHoraEstado.where()
    return AltasBajasHora.where(:id => @altasbajashoras_ids).includes(:persona)
  end

  def altas_bajas_horas_permitidas_bajas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where(:fecha_baja => nil).includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_efectivas_bajas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_permitidas_altas_notificadas
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('extract(month from fecha_alta) = ?', 5).where('extract(year   from fecha_alta) = ?', 2015)
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Notificado" || a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
        @altasbajashoras_ids << a.id
      end
    end
    #AltasBajasHoraEstado.where()
    return AltasBajasHora.where(:id => @altasbajashoras_ids)
  end


  def horas_novedades
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('extract(month from fecha_alta) = ?', 5).where('extract(year   from fecha_alta) = ?', 2015)
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
        @altasbajashoras_ids << a.id
      end
    end
    return AltasBajasHora.where(:id => @altasbajashoras_ids)
  end
  #altas_bajas_horas_permitidas_altas_notificadas
end
