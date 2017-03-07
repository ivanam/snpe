class Cargo < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada

  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'cargo_id', dependent: :destroy
  has_many :estados, :class_name => 'CargoEstado', :foreign_key => 'cargo_id', dependent: :destroy

  validate :cargo_ocupado

  validate :cargo_jerarquico

  #-----------------------------------------------------------------------------------------------------------
  def cargo_ocupado
    "Revisa si existe una persona en el cargo"
    
    if Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_equivalentes(self.cargo)) != []
      errors.add(:persona, "no puede tomar el cargo ya se encuentra ocupado")
    end

  end

  def cargo_jerarquico
    "Revisa si existe la persona en el establecimiento con un cargo jerarquico asignado"
    
    if Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_jerarquicos, persona_id: self.persona_id) != []
      errors.add(:persona, "no puede tomar el cargo porque posee un cargo jerarquico")
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

end

  