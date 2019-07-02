Licencium.where(oficina: nil).each do |l|
    if l.altas_bajas_hora_id != null
      AltasBajasHora.where(:id => l.altas_bajas_hora_id).first.establecimiento_id
      @oficina = Establecimiento.where(:id => establecimiento_id).first.codigo_jurisdiccional
    elsif l.cargo_id != null
      Cargo.where(:id => l.cargo_id).first.establecimiento_id
      @oficina = Establecimiento.where(:id => establecimiento_id).first.codigo_jurisdiccional
    elsif l.cargo_no_docente_id != null
      CargoNoDocente.where(:id => l.cargo_no_docente_id).first.establecimiento_id
      @oficina = Establecimiento.where(:id => establecimiento_id).first.codigo_jurisdiccional
    end
    l.update!(:oficina => @oficina)
    l.save
  end
