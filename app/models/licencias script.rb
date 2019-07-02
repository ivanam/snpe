Licencium.where(oficina: nil).each do |l|
    @oficina = nil
    if l.altas_bajas_hora_id != nil
      reg = AltasBajasHora.where(:id => l.altas_bajas_hora_id).first
      if reg != nil
        e = reg.establecimiento_id
        @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional

      end 
    elsif l.cargo_id != nil
      reg= Cargo.where(:id => l.cargo_id).first
      if reg != nil
        e = reg.establecimiento_id
        @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional
      end
    elsif l.cargo_no_docente_id != nil
      reg = CargoNoDocente.where(:id => l.cargo_no_docente_id).first
      if reg != nil
        e = reg.establecimiento_id
        @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional
      end
    end
    if @oficina != nil
      l.update!(:oficina => @oficina)
      l.save
    end
  end


  Licencium.where(oficina: nil).each do |l|
    @oficina = nil
    if (l.created_at.to_date  > Date.today - 100)
      if l.altas_bajas_hora_id != nil
        reg= AltasBajasHora.where(:id => l.altas_bajas_hora_id).first
        if reg != nil
          e = reg.establecimiento_id
          @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional
        end
      end
      if @oficina != nil
        l.update!(:oficina => @oficina)
        l.save
      end
    end
  end



  Licencium.where(oficina: nil).each do |l|
    @oficina = nil
    if l.cargo_id != nil
      reg= Cargo.where(:id => l.cargo_id).first
      if reg != nil
        e = reg.establecimiento_id
        @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional
      end
    end
    if @oficina != nil
      l.update!(:oficina => @oficina)
      l.save
    end
  end


  Licencium.where(oficina: nil).each do |l|
    if (l.created_at.to_date  > Date.today - 4)
      @oficina = nil
      if l.cargo_no_docente_id != nil
        reg = CargoNoDocente.where(:id => l.cargo_no_docente_id).first
        if reg != nil
          e = reg.establecimiento_id
          @oficina = Establecimiento.where(:id => e).first.codigo_jurisdiccional
        end
      end
      if @oficina != nil
        l.update!(:oficina => @oficina)
        l.save
      end
    end
  end
