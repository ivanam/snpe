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

#ingresados HAY QUE ELIMINARLOS
dd = []
cant = 0
@results = AltasBajasHora.where(created_at: Date.parse("2019-08-05").beginning_of_day..Date.parse("2019-08-08").end_of_day).where(:lote_impresion_id => nil)
@results.each do |rr|
  if !rr.valid?
    if AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 1
      dd << rr
      cant = cant + 1
    end
  end
end


dd = []
ll = []
cant = 0
@results = AltasBajasHora.where(created_at: Date.parse("2019-07-22").beginning_of_day..Date.parse("2019-08-08").end_of_day).where(:lote_impresion_id => nil)
@results.each do |rr|
  if !rr.valid?
    if (AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 2 or AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 1 or AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 4) and AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.user_id != 1
      ll << rr
      cant = cant + 1
    end
  end
end



dd = []
ll = []
cant = 0
@results = AltasBajasHora.where(created_at: Date.parse("2019-08-05").beginning_of_day..Date.parse("2019-08-08").end_of_day).where(:lote_impresion_id => nil)
@results.each do |rr|
  if !rr.valid?
    if AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 2
      msg = rr.errors.full_messages.first
      establecimiento_users = EstablecimientosUsers.where(:establecimiento_id => rr.establecimiento_id).pluck(:user_id)
      user_id = UserRole.where(user_id: establecimiento_users, role_id: 4).where.not(:user_id => 23).last.user_id
      AltasBajasHoraEstado.create(:alta_baja_hora_id => rr.id, :estado_id => 3, :observaciones => msg, :user_id => user_id)
      dd << user_id
      ll << rr
      cant = cant + 1
    end
  end
end



dd = []
cant = 0
@results = AltasBajasHora.where(created_at: Date.parse("2019-08-05").beginning_of_day..Date.parse("2019-08-08").end_of_day).where(:lote_impresion_id => nil)
@results.each do |rr|
  if !rr.valid?
    if AltasBajasHoraEstado.where(:alta_baja_hora_id => rr.id).last.estado.id == 2
      dd << rr
      cant = cant + 1
    end
  end
end




dd = []
cant = 0
@results = AltasBajasHora.where(created_at: Date.parse("2019-08-05").beginning_of_day..Date.parse("2019-08-08").end_of_day).where.not(:lote_impresion_id => nil)
@results.each do |rr|
  if !rr.valid?
    dd << rr
    cant = cant + 1
  end
end
