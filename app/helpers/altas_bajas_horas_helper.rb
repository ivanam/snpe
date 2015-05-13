module AltasBajasHorasHelper
  def altas_bajas_horas_permitidas_altas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where('extract(month from fecha_alta) = ?', 5).where('extract(year   from fecha_alta) = ?', 2015)
  end

  def altas_bajas_horas_permitidas_bajas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where(:fecha_baja => nil).includes(:establecimiento, :persona)
  end

  def altas_bajas_horas_efectivas_bajas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").includes(:establecimiento, :persona)
  end
end
