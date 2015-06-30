module AltasBajasHorasHelper
  def altas_bajas_horas_permitidas_altas(mindate, maxdate)
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
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:secuencia => nil).where(:fecha_baja => nil).includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_efectivas_bajas(mindate, maxdate)
    @horas = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate)
    @horas_ids = []
    @horas.each do |h|
      if h.estado_actual == "Notificado_Baja" || h.estado_actual == "Chequeado_Baja" || h.estado_actual == "Impreso"
        @horas_ids << h.id
      end
    end
    return AltasBajasHora.where(:id => @horas_ids).includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_permitidas_altas_notificadas(mindate, maxdate)
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Notificado" || a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
        @altasbajashoras_ids << a.id
      end
    end
    return AltasBajasHora.where(:id => @altasbajashoras_ids)
  end


  def horas_novedades(mindate, maxdate)
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
        @altasbajashoras_ids << a.id
      end
    end
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate)
    @altasbajashoras.each do |a|
      if a.estado_actual == "Impreso" || a.estado_actual == "Chequeado_Baja"
        @altasbajashoras_ids << a.id
      end
    end
    return AltasBajasHora.where(:id => @altasbajashoras_ids)
  end
end
