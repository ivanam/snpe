class CargoNoDocente < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :alta_lote_impresion
  belongs_to :baja_lote_impresion
  has_many :estados, :class_name => 'CargoNoDocenteEstado', :foreign_key => 'cargo_no_docente_id', dependent: :destroy


  if false
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
     cargo_existe_reu = CargoNoDocente.where(id: self.id).where(:secuencia => 1000).first
     cargo_existe = CargoNoDocente.where(:persona_id => self.persona.id).where.not(estado: 'BAJ').where.not(estado: 'LIC').where.not(estado: 'LIC P/BAJ').where.not(estado: 'REU').where.not(secuencia: 1000).where.not(id: self.id).first
     if cargo_existe_reu == nil
       if cargo_existe != nil
          errors.add(:base, "Esta persona ya posee un cargo auxiliar")
       end
     end
   end  
  end




  def calcular_licencia(fecha_limite_inicio,fecha_limite_fin,posicion,anio_lic)
    total = 0
    case posicion
      #quinto A
       when 0
           articulos = "(291,242)"
      #quintoB 
       when 1
          articulos = "(292, 243, 377)"
      #razones particulares
      when 2
          articulos = "(348,286,287)"
      when 3
        articulos = "(301)"
      #22a o 23a
      when 4
        articulos = "(321,263)"
      #23b
      when 5
        articulos = "(322,264)"

      #anual vacaciones
      when 6
        articulos = "(241,289,365,366)"
      else
        articulos = 0
      end

    #licencias anuales
    if (anio_lic != 0 or posicion == 6)

      Licencium.where(cargo_no_docente_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+"and (anio_lic = "+ anio_lic +" or anio_lic != null)").each do |lic|
        if lic.fecha_hasta.nil?
          f_h = Date.today
        else
          f_h = lic.fecha_hasta
        end
        total = total + (f_h - lic.fecha_desde).to_i + 1
      end
      return total

    #licencias historicas
    elsif (fecha_limite_inicio == 0  and fecha_limite_fin == 0)
 
      Licencium.where(cargo_no_docente_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+"").each do |lic|
        if lic.fecha_hasta.nil?
          f_h = Date.today
        else
          f_h = lic.fecha_hasta
        end
        total = total + (f_h - lic.fecha_desde).to_i + 1
      end
      return total

    #licencias mensuales y anuales
    else
      Licencium.where(cargo_no_docente_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+" and fecha_desde BETWEEN '"+fecha_limite_inicio+"' and '"+fecha_limite_fin+"'").each do |lic|
       
        if lic.fecha_hasta.nil?
          f_h = Date.today
        else
          f_h = lic.fecha_hasta
        end
        total = total + (f_h - lic.fecha_desde).to_i + 1
      end
      return total
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
