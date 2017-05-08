module AsistenciaHelper
  def asistencia_alta_baja_horas(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_hora_id: nil)
  end

  def asistencia_cargos(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_cargo_id: nil)
  end

  def asistencia_cargo_no_docentes(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_cargo_no_docente_id: nil)
  end

  def asistencia_horas_notificados(anio, mes)
    @asistencias = asistencia_alta_baja_horas(anio, mes)
    if @asistencias != [] #and @asistencias.first.estado_actual == "Notificado"
      @hora_ids = @asistencias.pluck(:altas_bajas_hora_id)
      return AltasBajasHora.where(id: @hora_ids).includes(:persona)
    else
      return AltasBajasHora.where(id: nil).includes(:persona)
    end
  end

  def asistencia_cargos_notificados(anio, mes)
    @asistencias = asistencia_cargos(anio, mes)
    if @asistencias != [] #and @asistencias.first.estado_actual == "Notificado"
      @cargo_ids = @asistencias.pluck(:altas_bajas_cargo_id)
      return Cargo.where(id: @cargo_ids).includes(:persona)
    else
      return Cargo.where(id: nil).includes(:persona)
    end
  end

  def asistencia_cargo_no_docentes_notificados(anio, mes)
    @asistencias = asistencia_cargo_no_docentes(anio, mes)
    if @asistencias != [] #and @asistencias.first.estado_actual == "Notificado"
      @cargo_no_docente_ids = @asistencias.pluck(:altas_bajas_cargo_no_docente_id)
      return CargoNoDocente.where(id: @cargo_no_docente_ids).includes(:persona)
    else
      return CargoNoDocente.where(id: nil).includes(:persona)
    end
  end

  def asistencia_cargos_no_docente(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_cargo_id: nil)
  end

end
