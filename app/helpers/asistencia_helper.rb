module AsistenciaHelper
  def asistencia_cargos(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_cargo_id: nil)
  end

  def asistencia_cargos_notificados(anio, mes)
    @asistencias = asistencia_cargos(anio, mes)
    if @asistencias != [] and @asistencias.first.estado_actual == "Notificado"
      @cargo_ids = @asistencias.pluck(:altas_bajas_cargo_id)
      return Cargo.where(id: @cargo_ids)
    else
      return Cargo.where(id: nil)
    end
  end

   def asistencia_cargos_no_docente(anio, mes)
    @asistencias = Asistencium.where(anio_periodo: anio, mes_periodo: mes).where.not(altas_bajas_cargo_id: nil)
  end

  def asistencia_cargos_no_docente_notificados(anio, mes)
    @asistencias = asistencia_cargos_no_docente(anio, mes)
    if @asistencias != [] and @asistencias.first.estado_actual == "Notificado"
      @cargo_no_doc_ids = @asistencias.pluck(:altas_bajas_cargo_id)
      return CargoNoDocentes.where(id: @cargo_no_doc_ids)
    else
      return CargoNoDocentes.where(id: nil)
    end
  end
end
