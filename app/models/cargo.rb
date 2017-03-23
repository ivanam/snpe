class Cargo < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada

  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'cargo_id', dependent: :destroy
  has_many :estados, :class_name => 'CargoEstado', :foreign_key => 'cargo_id', dependent: :destroy

  validate :cargo_ocupado

  validate :cargo_jerarquico

  validate :sit_revista

  #-----------------------------------------------------------------------------------------------------------
  def cargo_ocupado
    "Revisa si existe una persona en el cargo"
    if self.establecimiento.nivel_id.to_i == 1 # Inicial
      cargo_ocupado_primaria(self.establecimiento_id, self.cargo)
    elsif self.establecimiento.nivel_id.to_i == 2 # Primaria
      cargo_ocupado_primaria(self.establecimiento_id, self.cargo)
    elsif self.establecimiento.nivel_id.to_i == 3 # Secundaria
      print "lala"
    else
      errors.add(:establecimiento, "no tiene nivel asignado")
    end
  end

  def cargo_ocupado_primaria(establecimiento_id, cargo)
    if (Funcion::DIRECTOR_CATEGORIAS.include? cargo) || (Funcion::VICEDIRECTOR_CATEGORIAS.include? cargo)
      cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: Funcion.cargos_equivalentes(cargo))
      if cargos != []
        #self.sit_revista
        errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
      end
    end
  end

  #------------------------------------------------------------------------------------------------------------
  def cargo_jerarquico
    "Revisa si existe la persona en el establecimiento con un cargo jerarquico asignado"
    
    if Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_jerarquicos, persona_id: self.persona_id) != []
      errors.add(:persona, "no puede tomar el cargo porque posee un cargo jerarquico")
    end
  end

  def sit_revista
    # Revisa si corresponde la sitacion revista
    if !(Funcion::DIRECTOR_CATEGORIAS.include? self.cargo) || (Funcion::VICEDIRECTOR_CATEGORIAS.include? self.cargo)
      # Cargos jerarquicos
      cargo_actuales = Cargo.where(establecimiento_id: self.establecimiento_id, cargo: self.cargo, turno: self.turno, estado: "ALT")
      if  cargo_actuales != []
      # Existen cargos
        if self.situacion_revista == "1-1"
          errors.add(:base, self.persona.to_s + ": el cargo ya se encuentra ocupado el cargo por " + cargo_actuales.first.persona.to_s + " debe realizar la baja del cargo anterior")
        elsif self.situacion_revista == "1-2"
          errors.add(:persona, "ya se encuentra ocupado el cargo la baja del cargo anterior")
        end
      else
      # No existen cargos
        if (self.situacion_revista == "1-3") || (self.situacion_revista == "2-1") || (self.situacion_revista == "2-2") || (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-5")
          errors.add(:base, "No posee titular o interino para reemplazar o suplir")
        end
      end
    end
  end

  def incompatibilidad
    print "cargar algo"
  end
  #-----------------------------------------------------------------------------------------------------------
  
  def ina_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_justificada.to_s
    end
  end

  def ina_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_injustificada.to_s
    end
  end

  def lleg_tarde_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_justificada.to_s
    end
  end

  def lleg_tarde_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_injustificada.to_s
    end
  end

  def estado_actual
    @relation = CargoEstado.where(:cargo_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_anterior
    @relation = CargoEstado.where(:cargo_id => self.id).last
    @relation = CargoEstado.where(:cargo_id => self.id).where.not(id: @relation.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end 

  def cargo_equivalentes_escuela
    return Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_equivalentes(self.cargo))  
  end
  

end

  