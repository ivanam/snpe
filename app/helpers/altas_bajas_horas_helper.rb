module AltasBajasHorasHelper
  def altas_bajas_horas_permitidas
    return AltasBajasHora.where(:establecimiento_id => session[:establecimiento])
  end
end
