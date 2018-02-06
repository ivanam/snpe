module AltasBajasHorasHelper
  def altas_bajas_horas_permitidas_altas(mindate, maxdate)
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento])
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Ingresado" || a.estado_actual == "Cancelado"
        @altasbajashoras_ids << a.id
      end
    end
    return AltasBajasHora.where(:id => @altasbajashoras_ids).includes(:persona,:establecimiento)
  end

  def altas_bajas_horas_permitidas_bajas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:estado => "LIC P/BAJ").where("fecha_baja = '0000-00-00' or fecha_baja is null").includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_modificacion 
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:estado => "LIC P/BAJ").includes(:establecimiento, :persona)
  end

  def select_planes_permitidos
    @plan_ids = EstablecimientoPlan.where(:establecimiento_id => session[:establecimiento]).map(&:plan_id)          
    @planes_permitidos = Plan.where(:id => @plan_ids)
  end

  def select_materias_permitidas(plan_id, anio)
    @materias_ids = Despliegue.where(:plan_id => plan_id, :anio => anio).map(&:materium_id)
    @materias_permitidas = Materium.where(:id => @materias_ids)
  end

  def altas_bajas_horas_efectivas_bajas(mindate, maxdate)
    @horas_ids = []
    @horas = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:estado => "LIC P/BAJ")
    @horas.each do |h|
      if h.estado_actual == "Notificado_Baja"
        @horas_ids << h.id
      end
    end
    @horas = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
    @horas.each do |h|
      if h.estado_actual == "Chequeado_Baja" || h.estado_actual == "Impreso"
        @horas_ids << h.id
      end
    end
    return AltasBajasHora.where(:id => @horas_ids).includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_permitidas_altas_notificadas(mindate, maxdate)
    @altasbajashoras_ids = []
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento])
    @altasbajashoras.each do |a|
      if a.estado_actual == "Notificado"
        @altasbajashoras_ids << a.id
      end
    end
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
    @altasbajashoras.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Impreso" || a.estado_actual == "Cobrado" 
        @altasbajashoras_ids << a.id
      end
    end
    return AltasBajasHora.where(:id => @altasbajashoras_ids).includes(:persona).includes(:materium)
  end


  def horas_novedades(mindate, maxdate)
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento])
    @altasbajashoras_ids = []
    @altasbajashoras.each do |a|
      if a.estado_actual == "Chequeado" || a.estado_actual == "Chequeado_Baja"
        @altasbajashoras_ids << a.id
      end
    end
    @altasbajashoras = AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where("( fecha_alta >= '" + mindate.to_s + "' and fecha_alta <= '" + maxdate.to_s + "' ) or ( updated_at >= '" + mindate.to_s + "' and updated_at <= '" + maxdate.to_s + "' )")
    @altasbajashoras.each do |a|
      if a.estado_actual == "Impreso" || a.estado_actual == "Cobrado"
        @altasbajashoras_ids << a.id
      end
    end

    return AltasBajasHora.where(:id => @altasbajashoras_ids).includes(:persona, :materium)
  end

  def con_licencia(altasbajashoras)
    @titular = altasbajashoras.where(situacion_revista: "1-1").first
    #@suplentes= altasbajashoras.where(situacion_revista: "1-003")
    if AltasBajasHora.where(altas_bajas_hora_id: Suplente.where(id: @titular.suplente_id).first.altas_bajas_hora_id).situacion_revista == "1-3" then
      @titular = altasbajashoras.where(situacion_revista: "1-2").first
    end

    if @titular.suplente_id != nil then
      @suplente = AltasBajasHora.where(id: Suplente.where(id: @titular.suplente_id).first.altas_bajas_hora_id)  
      while @suplente.first.suplente_id != nil do
        @suplente = AltasBajasHora.where(id: Suplente.where(id: @suplente.suplente_id).first.altas_bajas_hora_id)
      end
      @ver_licencia = @suplente
    else
      @ver_licencia = @titular
    end
    return Licencium.where(altas_bajas_hora_id: @ver_licencia, vigente: "Vigente")
  end

  
  def con_licencia_interino(altasbajashoras)
    @titular = altasbajashoras.where(situacion_revista: "1-1").first
    return Licencium.where(altas_bajas_hora_id: @titular, vigente: "Vigente")
  end

  #Articulo sin goce de haberes
  def con_licencia_reemplazante(altasbajashoras)
    if altasbajashoras.where(situacion_revista: "1-1").first then #Titular
      @primer = altasbajashoras.where(situacion_revista: "1-1").first #Titular
    else 
      @primer = altasbajashoras.where(situacion_revista: "1-2").first #Interino
    end
     if @primer.suplente_id != nil then
      @suplente = altasbajashoras.where(id: Suplente.where(id: @primer.suplente_id).first.altas_bajas_hora_id)  
      while @suplente.first.suplente_id != nil do
        @suplente = altasbajashoras.where(id: Suplente.where(id: @suplente.suplente_id).first.altas_bajas_hora_id)
      end
      @ver_licencia = @suplente
    else
      @ver_licencia = @primer
    end
    if Licencium.joins(:articulo).where(altas_bajas_hora_id: @ver_licencia, vigente: "Vigente", articulos: {con_goce: false}).first then
      return @ver_licencia #Hay licencias para esas horas
    else
      return [] #No hay licencias para esas horas
    end
  end 

 #Articulo con goce de haberes
  def con_licencia_suplente (altasbajashoras)
    if altasbajashoras.where(situacion_revista: "1-1").first then
      @primer = altasbajashoras.where(situacion_revista: "1-1").first
    else 
      @primer = altasbajashoras.where(situacion_revista: "1-2").first
    end
    if @primer.suplente_id != nil then
      @suplente = altasbajashoras.where(id: Suplente.where(id: @primer.suplente_id).first.altas_bajas_hora_id)  
      while @suplente.first.suplente_id != nil do
        @suplente = altasbajashoras.where(id: Suplente.where(id: @suplente.suplente_id).first.altas_bajas_hora_id)
      end
      @ver_licencia = @suplente
    else
      @ver_licencia = @primer
    end    
    if Licencium.joins(:articulo).where(altas_bajas_hora_id: @ver_licencia, vigente: "Vigente", articulos: {con_goce: true}).first then
      return @ver_licencia #Hay licencias para esas horas
    else
      return [] #No hay licencias para esas horas
    end
  end
  def cargopormateria(altasbajashoras)
    return altasbajashoras.all
  end
end
