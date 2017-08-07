class Cargo < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :funcion

 
  has_many :estados, :class_name => 'CargoEstado', :foreign_key => 'cargo_id', dependent: :destroy

  validates :fecha_alta, presence: true
  validates :cargo, presence: true
  validates :situacion_revista, presence: true


  validate :sit_revista
  validate :cargo_jerarquico
  validate :controlar_turno

  before_update :dar_baja


  #-----------------------------------------------------------------------------------------------------------


  def controlar_turno
    if (self.estado != "LIC" && self.estado != "LIC P/BAJ") && (self.turno == nil || self.turno == "" )
      errors.add(:turno, "no puede estar vacio")
    end
  end

  def cargo_ocupado
    #Revisa si existe una persona en el cargo
    if self.establecimiento.nivel_id.to_i == 1 # Inicial
      cargo_ocupado_primaria(self.establecimiento_id, self.cargo)
    elsif self.establecimiento.nivel_id.to_i == 2 || self.establecimiento.nivel_id.to_i == 7 || self.establecimiento.nivel_id.to_i == 8  # Primaria, Especial y hospitalaria
      cargo_ocupado_primaria(self.establecimiento_id, self.cargo)
    elsif self.establecimiento.nivel_id.to_i == 3 # Secundaria
      cargo_ocupado_secundaria(self.establecimiento_id, self.cargo)
    else
      errors.add(:establecimiento, "no tiene nivel asignado")
    end
  end

  def cargo_ocupado_secundaria(establecimiento_id, cargo)
    if Funcion.cargos_jerarquicos.include? cargo
      #Controla cuando en caso de alta de un cargo jerarquico
      if Funcion::DIRECTOR_CATEGORIAS.include? cargo
        cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: Funcion.cargos_equivalentes(cargo)).where.not(estado: 'BAJ').where.not(id: self.id).order(fecha_alta: :desc).limit(1) #miro los cargos de la misma categoria
      else
        cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: Funcion.cargos_equivalentes(cargo), turno: self.turno).where.not(estado: 'BAJ').where.not(id: self.id).order(fecha_alta: :desc).limit(1) #miro los cargos de la misma categoria y turno
      end
      
      if cargos != []
        if cargos.where(estado: "ALT") != [] # si esta activo no se puede, cargo se encuentra ocupado
          errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
        elsif cargos.where(estado: "ART") != [] # se el cargo esta licenciado con goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
          elsif (self.situacion_revista == "1-3")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        elsif cargos.where(estado: "LIC") != [] # se el cargo esta licenciado sin goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
          elsif (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-4")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        end
      else
        if self.estado == "ALT" && ( self.situacion_revista != "1-1" && self.situacion_revista != "1-2")
          errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
        end
      end
    end
  end

  def cargo_ocupado_primaria(establecimiento_id, cargo)
    if Funcion.cargos_jerarquicos.include? self.cargo
      #Controla cuando en caso de alta de un cargo jerarquico
      cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: Funcion.cargos_equivalentes(cargo)).where.not(estado: 'BAJ').where.not(id: self.id).order(fecha_alta: :desc).take #miro los cargos de la misma categoria
      if cargos != nil
        if cargos.estado == "ALT" # si esta activo no se puede, cargo se encuentra ocupado
          errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.persona.to_s)
        elsif cargos.estado == "ART" # se el cargo esta licenciado con goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.persona.to_s)
          elsif (self.situacion_revista == "1-3")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        elsif cargos.estado == "LIC" # se el cargo esta licenciado sin goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.persona.to_s)
          elsif (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-4")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        end
      else
        if self.estado == "ALT" && ( self.situacion_revista != "1-1" && self.situacion_revista != "1-2")
          errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
        end
      end
    end
  end

  #------------------------------------------------------------------------------------------------------------
  def cargo_jerarquico
    #Revisa si existe la persona en el establecimiento con un cargo jerarquico asignado
    #Cargo.find(self.cargo_id).update!(estado: estado)
    if self.estado != "LIC P/BAJ" && self.estado != "LIC"
      if Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_jerarquicos, persona_id: self.persona_id, estado: "ALT").where.not(id: self.id).order(fecha_alta: :desc).limit(1) != []
        errors.add(:persona, "no puede tomar el cargo porque posee un cargo jerarquico")
      end
      if (Funcion.cargos_jerarquicos.include? self.cargo) && (Cargo.where(establecimiento_id: self.establecimiento_id, persona_id: self.persona_id, estado: "ALT").where.not(id: self.id).order(fecha_alta: :desc).limit(1) != [])
        errors.add(:persona, "ya posee otro cargo en la escuela")
      end
    end
  end

  def sit_revista
    # Revisa si corresponde la sitacion revista
    if self.estado != "LIC P/BAJ" && self.estado != "LIC"
      if self.estado == "ALT"

        if !(Funcion.cargos_jerarquicos.include? self.cargo)
          # Cargos jerarquicos
          cargo_actuales = Cargo.where(establecimiento_id: self.establecimiento_id, cargo: self.cargo, turno: self.turno, anio: self.anio, division: self.division, grupo_id: self.grupo_id).where.not(id: self.id).where.not(estado: "BAJ").order(fecha_alta: :desc).take
          if cargo_actuales != nil
            if  cargo_actuales.estado == "ALT"
            # Existen cargos
              errors.add(:base, self.persona.to_s + ": el cargo ya se encuentra ocupado por " + cargo_actuales.persona.to_s + " debe realizar la baja del cargo anterior")
            elsif cargo_actuales.estado == "LIC"
              if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
                errors.add(:base, "No se puede dar de alta el cargo, ya se ocupado por " + cargo_actuales.persona.to_s + "que se encuentra de licencia")
              elsif (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-4")
                errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
              end
            elsif cargo_actuales.estado == "ART" # se el cargo esta licenciado con goce, solamente puede ponerse suplente
              if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
                errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargo_actuales.persona.to_s)
              elsif (self.situacion_revista == "1-3")
                errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
              end
            end
          else
            if self.estado == "ALT" && ( self.situacion_revista != "1-1" && self.situacion_revista != "1-2")
              errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
            end
          end
        else
          self.cargo_ocupado
        end
      end
    end

  end

  def incompatibilidad
    print "cargar algo"
  end


  def dar_baja
    if self.fecha_baja != "" && self.fecha_baja != nil
      if self.estado == "LIC" || self.estado == "ART"
        errors.add(:base, self.persona.to_s + "debe terminar la licencia antes de generar la baja")
        return false
      end
      self.estado = "BAJ"
    end
    return true
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

  def paro(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.paro.to_s
    end
  end

  def licencia_d(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.licencia_d.to_s
    end
  end

  def observaciones_por_periodo(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "Vacio"
    else
      return @asistencia.observaciones.to_s
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

  def curso_division
    return self.anio.to_s + "/" + self.division.to_s
  end

end
