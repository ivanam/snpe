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

  def select_planes_permitidos 
    if current_user.role? :sadmin
      #Si el usuario es superadmin muestro todos las planes
      @planes_permitidos = Plan.all 
    else
      #Si el usuario es otro muestro los planes de ese establecimiento
      @plan_ids = EstablecimientoPlan.where(:establecimiento_id => session[:establecimiento]).map(&:plan_id)          
      @planes_permitidos = Plan.where(:id => @plan_ids)
    end
  end

  def select_materias_permitidas(plan_id, anio)
    @materias_ids = Despliegue.where(:plan_id => plan_id, :anio => anio).map(&:materium_id)
    @materias_permitidas = Materium.where(:id => @materias_ids)
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
