class Cargo < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :funcion

  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'cargo_id', dependent: :destroy
  has_many :estados, :class_name => 'CargoEstado', :foreign_key => 'cargo_id', dependent: :destroy

  validates :turno, presence: true
  validates :fecha_alta, presence: true
  validates :cargo, presence: true
  validates :situacion_revista, presence: true


  validate :sit_revista
  validate :cargo_jerarquico

  #-----------------------------------------------------------------------------------------------------------


  def cargo_ocupado
    #Revisa si existe una persona en el cargo
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
    if Funcion.cargos_jerarquicos.include? self.cargo
      #Controla cuando en caso de alta de un cargo jerarquico
      cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: Funcion.cargos_equivalentes(cargo)).where("cargo != 'BAJ'").where.not(id: self.id) #miro los cargos de la misma categoria
      if cargos != []
        if cargos.where(cargo: "ALT") != [] # si esta activo no se puede, cargo se encuentra ocupado
          errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
        elsif cargos.where(cargo: "ART") # se el cargo esta licenciado con goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
          elsif (self.situacion_revista == "1-3")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        elsif cargos.where(cargo: "LIC") # se el cargo esta licenciado sin goce, solamente puede ponerse suplente
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
          elsif (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-4")
            errors.add(:base, self.persona.to_s + "no puede tomar el cargo la situación de revista no corresponde")
          end
        end
      end
    else
      # self.cargo_jerarquico #Agrega un error cuando la persona ya posee otro cargo que sea jerarquico en la institutacion
      # cargos = Cargo.where(establecimiento_id: establecimiento_id, cargo: cargo, estado: "ALT")
      # if cargos != []
      #   #self.sit_revista
      #   errors.add(:base, self.persona.to_s + "no puede tomar el cargo ya se encuentra ocupado por" + cargos.first.persona.to_s)
      # end

    end
  end

  #------------------------------------------------------------------------------------------------------------
  def cargo_jerarquico
    #Revisa si existe la persona en el establecimiento con un cargo jerarquico asignado
    if Cargo.where(establecimiento_id: self.establecimiento_id, cargo: Funcion.cargos_jerarquicos, persona_id: self.persona_id, estado: "ALT").where.not(id: self.id) != []
      errors.add(:persona, "no puede tomar el cargo porque posee un cargo jerarquico")
    end
    if (Funcion.cargos_jerarquicos.include? self.cargo) && (Cargo.where(establecimiento_id: self.establecimiento_id, persona_id: self.persona_id, estado: "ALT").where.not(id: self.id) != [])
      errors.add(:persona, "ya posee otro cargo en la escuela")
    end
  end

  def sit_revista
    # Revisa si corresponde la sitacion revista
    if self.estado == "ALT"
      if !(Funcion.cargos_jerarquicos.include? self.cargo)
        # Cargos jerarquicos
        cargo_actuales = Cargo.where(establecimiento_id: self.establecimiento_id, cargo: self.cargo, turno: self.turno, anio: self.anio, curso: self.curso)
        if  cargo_actuales.where(estado: "ALT") != []
        # Existen cargos
          errors.add(:base, self.persona.to_s + ": el cargo ya se encuentra ocupado el cargo por " + cargo_actuales.where(estado: "ALT").first.persona.to_s + " debe realizar la baja del cargo anterior")
          # if self.situacion_revista == "1-1"
          #   errors.add(:base, self.persona.to_s + ": el cargo ya se encuentra ocupado el cargo por " + cargo_actuales.first.persona.to_s + " debe realizar la baja del cargo anterior")
          # else self.situacion_revista == "1-2"
          #   errors.add(:persona, "ya se encuentra ocupado el cargo, genere la baja del cargo anterior")
          #end
        elsif cargo_actuales.where(estado: "LIC") != []
          if (self.situacion_revista == "1-1") || (self.situacion_revista == "1-2")
            errors.add(:base, "No se puede dar de alta el cargo, ya se ocupado por " + cargo_actuales.where(estado: "LIC").first.persona.to_s + "que se encuentra de licencia")
          end
        else
        # No existen cargos
          if (self.situacion_revista == "1-3") || (self.situacion_revista == "2-1") || (self.situacion_revista == "2-2") || (self.situacion_revista == "2-3") || (self.situacion_revista == "2-4") || (self.situacion_revista == "2-5")
            errors.add(:base, "No posee titular o interino para reemplazar o suplir")
          end
        end
      else
        self.cargo_ocupado
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