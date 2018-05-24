class CargoNoDocente < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :alta_lote_impresion
  belongs_to :baja_lote_impresion
  has_many :estados, :class_name => 'CargoNoDocenteEstado', :foreign_key => 'cargo_no_docente_id', dependent: :destroy


  if true
    validates :turno, presence: true
    validates :fecha_alta, presence: true
    validates :cargo, presence: true
    validates :situacion_revista, :presence => true

    validate :cargo_existente, if: :no_es_licencia_para_baja

    before_update :dar_baja
  end

  def no_es_licencia_para_baja
    self.estado != "LIC P/BAJ"
  end
  
  def cargo_existente
     #Revisa si existe una persona en el cargo
     
   if self.estado == 'ALT'
     cargo_existe = CargoNoDocente.where(:persona_id => self.persona.id).where.not(estado: 'BAJ').where.not(estado: 'LIC').where.not(estado: 'LIC P/BAJ').where.not(id: self.id).first
     if cargo_existe != nil
       errors.add(:base, "Esta persona ya posee un cargo auxiliar")
     end
   end  
  end

   #-----------------------------------------------------------------------------------------------------------
  
  def ina_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_justificada.to_s
    end
  end

  def ina_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_injustificada.to_s
    end
  end

  def lleg_tarde_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_justificada.to_s
    end
  end

  def lleg_tarde_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_injustificada.to_s
    end
  end

  def paro(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.paro.to_s
    end
  end

  def licencia_d(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.licencia_d.to_s
    end
  end

  def observaciones_por_periodo(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_cargo_no_docente_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "Vacio"
    else
      return @asistencia.observaciones.to_s
    end
  end


  def estado_actual
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_anterior
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).last
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).where.not(id: @relation.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
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

end
