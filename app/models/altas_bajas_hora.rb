class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :lote_impresion
  has_many :estados, :class_name => 'AltasBajasHoraEstado', :foreign_key => 'alta_baja_hora_id', dependent: :destroy
  belongs_to :empresa
  belongs_to :lugar_pago
  belongs_to :materium
  belongs_to :plan


  if true
    validates :fecha_alta, :presence => true
    validates :situacion_revista, :presence => true
    validates :horas, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }
    validates :anio, length: { minimum: 1, maximum: 2}, :numericality => { :greater_than_or_equal_to => 0, :message => "Ingrese un número entre 0 y 6" }, if: :no_es_licencia_para_baja
    validates :division, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }, if: :no_es_licencia_para_baja
    validates :persona_id, :presence => true
    validates :plan_id, :presence => true, if: :no_es_licencia_para_baja, if: :motivo_baja_sin_controles
    validates :materium_id, :presence => true, if: :no_es_licencia_para_baja, if: :motivo_baja_sin_controles
    validates :turno, :presence => true, if: :no_es_licencia_para_baja, if: :motivo_baja_sin_controles


  # # #Validación de alta
    before_create :validar_horas
    validate :validar_alta, if: :motivo_baja_sin_controles
    #validate :validar_nivel_superior
    before_save :actualizar_materia
    before_update :dar_baja
    before_create :control_horas
  end


  #-------------------------------------
  MATERIAS_SIN_VALIDACION = [1994] #codigo materia 5881
  EXCEPCION_MATERIA_CON_VALIDACION = [1473] #MATERIAS Q ESTAN EN UN PLAN SIN VALIDACION
  ANIO = ["0","1","2","3","4","5","6","7","8","9"]
  PLANES_SIN_VALIDACION = [122,3000,261,256] #Listado de planes que no requieren validacion
  LONGITUD_CODIGO = 4
  MATERIA_CON_CONTROL_DE_MAXIMO = [1729,1746,682] #materia 2255 etp
  CANT_MAXIMA = 11

  def self.horas_persona(dni)
    hora_ids = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC' or estado = 'ART')").map(&:id)
    return AltasBajasHora.where(id: hora_ids).includes(:establecimiento)
  end


  def calcular_licencia(fecha_limite_inicio,fecha_limite_fin,posicion,anio_lic)
    total = 0
    case posicion
      #5 A AUXILIAR
      when 0
           articulos = "(291)"
      #5 A DOCENTE
      when 10
           articulos = "(242)"
      #5B AUXILIAR
      when 1
          articulos = "(292)"
      #5B DOCENTE
      when 11
          articulos = "(243)"
      #5B AUXILIAR MITAD DE SUELDO
      when 2
        articulos = "(399)"
      #DOCENTE 5B MITAD DE SUELDO
      when 12
        articulos = "(377)"
      #AUXILIAR RAZONES PARTICULARES
      when 3
          articulos = "(348)"
      #DOCENTE RAZONES PARTICULARES   
      when 13
          articulos = "(287)"
      #DIA FEMENINO
      when 4
        articulos = "(301)"
      #22A
      when 5
        articulos = "(321)"
      #22B
      when 6
        articulos = "(322)"
      #22C
      when 7
        articulos = "(323)"
      #22D
      when 8
        articulos = "(324)"
      #22e
      when 9
        articulos = "(325)"
      #23A
      when 15
        articulos = "(263)"
      #23B
      when 16
        articulos = "(264)"
      #23D
      when 17
        articulos = "(265)"
      #23E
      when 18
        articulos = "(266)"



      #anual vacaciones
      when 20
        articulos = "(241,289,365,366)"
      else
        articulos = 0
      end

    #licencias anuales
    if (anio_lic != 0 or posicion == 20)
      
      Licencium.where(altas_bajas_hora_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+"and (anio_lic = "+ (anio_lic.to_s) +" or anio_lic != null)").each do |lic|
        if lic.fecha_hasta.nil?
          f_h = Date.today
        else
          f_h = lic.fecha_hasta
        end
        total = total + (f_h - lic.fecha_desde).to_i + 1
      end
      if total == 0
        return "0 (o no se han registrado días en este sistema)"
      else
        return total
      end

    #licencias historicas
    elsif (fecha_limite_inicio == 0  and fecha_limite_fin == 0)
 
      Licencium.where(altas_bajas_hora_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+"").each do |lic|
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
      Licencium.where(altas_bajas_hora_id: self.id).where.not(vigente: "Cancelada").where("articulo_id in "+articulos+" and fecha_desde BETWEEN '"+fecha_limite_inicio+"' and '"+fecha_limite_fin+"'").each do |lic|
       
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

  def calcular_dias_restantes_licencia_anual(fecha_antiguedad,cantidad_dias)
      if cantidad_dias.is_a? String
        return "-"

      elsif fecha_antiguedad != "0000-00-00" and fecha_antiguedad != nil
        antiguedad = fecha_antiguedad.to_date.year.to_i
          if antiguedad <= 5
            return (20 - cantidad_dias)
          elsif antiguedad <= 10
            return (25 - cantidad_dias)
          elsif antiguedad <= 15
            return (30 - cantidad_dias)
          elsif antiguedad <= 20
            return (35 - cantidad_dias)
          elsif antiguedad <= 25
            return (40 - cantidad_dias)
          elsif antiguedad <= 30
            return (45 - cantidad_dias)
          elsif antiguedad <= 35
            return (50 - cantidad_dias)
          elsif antiguedad <= 40
            return (55 - cantidad_dias)
          elsif antiguedad > 40
            return (60 - cantidad_dias)
          else
            return "error antigüedad"
          end

      else
        return "no tiene resgitrada antigüedad"

      end
  end









  def control_horas
    
    if !(PLANES_SIN_VALIDACION.include?(Plan.find(self.plan_id).codigo) or MATERIA_CON_CONTROL_DE_MAXIMO.include? self.materium_id or MATERIAS_SIN_VALIDACION.include? self.materium_id)
      self.horas = Despliegue.where(plan_id: self.plan_id, materium_id: self.materium_id, anio: self.anio).first.carga_horaria
    end
  end

  def no_es_licencia_para_baja
    self.estado != "LIC P/BAJ"
  end

  def motivo_baja_sin_controles
    #salta validaciones si es baja por jubilacion y por cierre de curso
    !(self.motivo_baja == "2" or self.motivo_baja == "6" or self.motivo_baja == nil or self.motivo_baja == "10")
  end

  def plan_con_validacion
    if self.plan_id != nil
      return !PLANES_SIN_VALIDACION.include?(Plan.find(self.plan_id).codigo)
    else 
      return true #Si aun no se ingreso plan, se requerien todas las validaciones
    end
  end

  #Método que valida el alta de un paquete de horas
  def validar_alta
    if self.estado == 'ALT'
      establecimiento = Establecimiento.find(self.establecimiento_id)
      nivel = establecimiento.nivel
      if (nivel == nil) || (nivel != nil && nivel.nombre != "Superior")
        if validar_situacion_revista
          if plan_con_validacion
            validar_titular
            validar_interino
            validar_reemplazante
            validar_suplente
          end
        end  
      else
          validar_situacion_revista
          validar_situacion_revista_superior
          validar_nivel_superior
          validar_suplente_nivel_superior
          validar_reemplazante_nivel_superior
      end  
    end
  end

  def validar_situacion_revista_superior

    if self.situacion_revista == '1-1'
        horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id, situacion_revista: '1-2').where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").first
        if horas != nil 
            errors.add(:base,"No puede darse de alta a un TITULAR si la situación de revista de la pareja pedagógica es 'Interina'")        
        end
     elsif self.situacion_revista == '1-2'
        horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id, situacion_revista: '1-1').where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").first
        if horas != nil 
            errors.add(:base,"No puede darse de alta a un INTERINO si la situación de revista de la pareja pedagógica es 'Titular'")        
        end
    end
    
  end

  def validar_horas
    
    cant_horas = 0
    if (MATERIA_CON_CONTROL_DE_MAXIMO.include? self.materium_id and self.horas != 0)
      
         cant_horas = AltasBajasHora.where(establecimiento_id: self.establecimiento_id).where(:materium_id => self.materium_id, anio: self.anio, division: self.division).where.not(estado: 'BAJ').where.not(estado: 'LIC P/BAJ').sum(:horas)
         #materia regionalizacion 
        if (self.materium_id == 682 and self.anio == 6)
            cantidad_max = 15
        elsif (self.materium_id == 682 and self.anio == 7)
            cantidad_max = 12 
        elsif (self.materium_id== 1746 and self.anio == 7) 
            cantidad_max = 10
        elsif (self.materium_id== 1729 and self.anio == 1) 
            cantidad_max = 7
        else 
            cantidad_max = 11
         end
         if (cant_horas + self.horas) > cantidad_max
              errors.add(:base,"error en la carga horaria, ya superó el máximo correspondiente a la materia "+ Materium.where(:id => self.materium_id).first.descripcion)
              return false
         end
    elsif !(MATERIAS_SIN_VALIDACION.include? self.materium_id or PLANES_SIN_VALIDACION.include?(Plan.find(self.plan_id).codigo)) or (EXCEPCION_MATERIA_CON_VALIDACION.include? Materium.where(id: self.materium_id).first.codigo)
      if (Despliegue.where(:materium_id => self.materium_id, :plan_id => self.plan_id, :anio => self.anio, :carga_horaria => self.horas ).first == nil or (self.horas ==0))
        errors.add(:base,"error en la carga horaria, no corresponde")
        return false   
      end

    elsif self.horas == 0
        errors.add(:base,"error en la carga horaria, no corresponde")
        return false   
    end
  end

  def validar_situacion_revista

    if self.situacion_revista == '1-3' || self.situacion_revista == '2-3' || self.situacion_revista == '2-4'
      titular = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id, situacion_revista:'1-1').where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").first
      interino = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id, situacion_revista:'1-2').where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").first
      if (titular == nil) && (interino == nil)      
        errors.add(:base,"No puede darse de alta un suplente ni reemplazante si no existe titular o interino en el cargo")        
      end
    end
  end

  #2- hay un titular y se quiere dar de alta un titular
  #3- hay un (interino,reemplazante, supl. larga, supl. corta, etc.) y se quiere de alta un titular
  def validar_titular 
      if self.situacion_revista == '1-1'
        alta_horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")
    
        if (alta_horas != nil)
          titular = alta_horas.where(situacion_revista: "1-1").first
          if titular
            errors.add(:base,"Se quiere dar de alta un titular y ya existe uno. El titular en ese espacio curricular es #{titular.persona.to_s}")                
          else
            interino = alta_horas.where(situacion_revista: "1-2").first
            if interino
              errors.add(:base,"Se quiere dar de alta un titular y ya existe interino. El interino en ese espacio curricular es #{interino.persona.to_s}")                
            end
          end
        end      
      end
  end

  #4- hay un interino y se quiere dar de alta un interino
  #5- hay un (interino,reemplazante, supl. larga, supl. corta, etc.) y se quiere dar de alta interino
  def validar_interino


      if self.situacion_revista == '1-2'
        alta_horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")      
        if (alta_horas != nil)
          interino = alta_horas.where(situacion_revista: "1-2").first
          if interino
            errors.add(:base,"Se quiere dar de alta un interino y ya existe uno. El interino en ese espacio curricular es #{interino.persona.to_s}")                
          else
            titular = alta_horas.where(situacion_revista: "1-1").first
            if titular
              errors.add(:base,"Se quiere dar de alta un interino y ya existe un titular. El titular en ese espacio curricular es #{titular.persona.to_s}")                
            end
          end
        end  
      end
  end

  #Se quiere crear un reemplazante
  def validar_reemplazante
    if self.situacion_revista == '1-3' 
      alta_horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")       
      if (!tiene_licencia_sin_goce(alta_horas))
        errors.add(:base,"Las horas a reemplazar no se encuentra con licencia sin goce de haberes.")                
      end
      #reemplazante_de = con_licencia_reemplazante(alta_horas) 
      #if (reemplazante_de == [])
      #  errors.add(:base,"Las horas a reemplazar no se encuentra con licencia sin goce de haberes.")                
      #end
    end
  end

  #Se quiere crear suplente de larga duracion o corta duracion
  def validar_suplente
    if self.situacion_revista == '2-3' || self.situacion_revista == '2-4' 
      alta_horas = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")      
      if (!tiene_licencia_con_goce(alta_horas))
        errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      end
      #suplente_de = con_licencia_suplente(alta_horas) 
      #if (suplente_de == [])
      #  errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      #end
    end
  end

  def validar_suplente_nivel_superior
    if self.situacion_revista == '2-3' || self.situacion_revista == '2-4' 
      cantidad_registros_total = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")      
      cantidad_registros_tit_int = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where(situacion_revista: ['1-1','1-2']).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").count
      horas_cant_lic = cantidad_registros_total.where(estado: 'ART').count
      horas_cant_alt = cantidad_registros_total.where(estado: 'ALT').count
      if horas_cant_lic <= 0 
        errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      elsif cantidad_registros_tit_int <= horas_cant_alt
        errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      end
    end
  end

  def validar_reemplazante_nivel_superior
    if self.situacion_revista == '1-3'
      cantidad_registros_total = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where.not(id: self.id).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )")      
      cantidad_registros_tit_int = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where(situacion_revista: ['1-1','1-2']).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").count
      horas_cant_lic = cantidad_registros_total.where(estado: 'LIC').count
      horas_cant_alt = cantidad_registros_total.where(estado: 'ALT').count
      if horas_cant_lic <= 0 
        errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      elsif cantidad_registros_tit_int <= horas_cant_alt
        errors.add(:base,"Las horas a suplantar no se encuentra con licencia con goce de haberes.")                
      end
    end
  end

  #Verifica si tomo articulo de licencia sin goce de haberes
  def tiene_licencia_sin_goce(altasbajashoras)
    horas_licenciadas = altasbajashoras.where(estado: 'LIC').first
    return (horas_licenciadas != nil)
  end

  #Verifica si tomo articulo de licencia con goce de haberes
  def tiene_licencia_con_goce(altasbajashoras)
    horas_licenciadas = altasbajashoras.where(estado: 'ART').first
    return (horas_licenciadas != nil)
  end

  #Articulo sin goce de haberes
  def con_licencia_reemplazante(altasbajashoras)
    if altasbajashoras.where(situacion_revista: "1-1").first #Titular
      primer = altasbajashoras.where(situacion_revista: "1-1").first #Titular
    else 
      primer = altasbajashoras.where(situacion_revista: "1-2").first #Interino
    end
     if primer.suplente_id != nil
      suplente = altasbajashoras.where(id: Suplente.where(id: primer.suplente_id).first.altas_bajas_hora_id)  
      while suplente.first.suplente_id != nil do
        suplente = altasbajashoras.where(id: Suplente.where(id: suplente.suplente_id).first.altas_bajas_hora_id)
      end
      ver_licencia = suplente
    else
      ver_licencia = primer
    end
    if Licencium.joins(:articulo).where(altas_bajas_hora_id: ver_licencia, vigente: "Vigente", articulos: {con_goce: false}).first
      return ver_licencia #Hay licencias para esas horas
    else
      return [] #No hay licencias para esas horas
    end
  end 

  #Articulo con goce de haberes
  def con_licencia_suplente(altasbajashoras)
    if altasbajashoras.where(situacion_revista: "1-1").first
      primer = altasbajashoras.where(situacion_revista: "1-1").first
    else 
      primer = altasbajashoras.where(situacion_revista: "1-2").first
    end
    if primer.suplente_id != nil
      suplente = altasbajashoras.where(id: Suplente.where(id: primer.suplente_id).first.altas_bajas_hora_id)  
      while suplente.first.suplente_id != nil do
        suplente = altasbajashoras.where(id: Suplente.where(id: suplente.suplente_id).first.altas_bajas_hora_id)
      end
      ver_licencia = suplente
    else
      ver_licencia = primer
    end    
    if Licencium.joins(:articulo).where(altas_bajas_hora_id: ver_licencia, vigente: "Vigente", articulos: {con_goce: true}).first
      return ver_licencia #Hay licencias para esas horas
    else
      return [] #No hay licencias para esas horas
    end
  end

  #Valido que la cantidad de docentes inscriptos en una materia no supere el maximo permitido por el despliegue (plan)
  def validar_nivel_superior    
    
    establecimiento = Establecimiento.find(self.establecimiento_id)
    nivel = establecimiento.nivel
    if nivel.nombre = "Superior" and (self.situacion_revista == '1-1' || self.situacion_revista == '1-2')
      #Obtengo el despliegue correspondiente a la materia y el plan
      despliegue = Despliegue.find_by(plan_id: self.plan_id, materium_id: self.materium_id)   
      #Cantidad de registros
      
      cantidad_registros = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).where(situacion_revista: ['1-1','1-2']).where(" (estado != 'LIC P/BAJ' and estado != 'BAJ' )").count
      if !(cantidad_registros < despliegue.cant_docentes)
        errors.add(:base,"Ya se cumplio el limite de cantidad de docentes en esa Materia")
      end
    end
  end

  def ina_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_justificada.to_s
    end
  end

  def ina_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_injustificada.to_s
    end
  end

  def lleg_tarde_justificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_justificada.to_s
    end
  end

  def lleg_tarde_injustificada(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_injustificada.to_s
    end
  end

  def paro(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.paro.to_s
    end
  end

  def licencia_d(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.licencia_d.to_s
    end
  end

  def observaciones_por_periodo(anio, mes)
    @asistencia = Asistencium.where(altas_bajas_hora_id: self.id, anio_periodo: anio, mes_periodo: mes ).first
    if @asistencia == nil
      return "Vacio"
    else
      return @asistencia.observaciones.to_s
    end
  end

  def estado_actual
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).last
    if @relation == nil
      return "Vacio"
    elsif @relation.estado.descripcion == "Cobrado" and AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id, estado_id: 7) != [] and AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id, estado_id: 8) == []
      return "Notificado_Baja"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_actual_s_cobro
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).where.not(estado_id: 10).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_anterior
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).last
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).where.not(id: @relation.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def cant_horas
    return self.horas
    
  end

  def plan_materia
    return self.plan.to_s + "/" + self.materium.to_s
  end

  def curso_division
    return self.anio.to_s + "/" + self.division.to_s
  end


  def dar_baja
    
    if self.fecha_baja != "" && self.fecha_baja != nil
      if self.estado == "LIC" || self.estado == "ART"
        errors.add(:base, self.persona.to_s + " debe terminar la licencia antes de generar la baja")
        return false
      end
      self.estado = "BAJ"
    end
    return true
  end

  #Revisar!!!
  def actualizar_materia    
    if self.materium_id == nil || self.materium_id == '' || self.materium_id == 0
      self.materium_id = Materium.where(codigo: self.codificacion).first.id
    end
  end

  def plan_materia
    return self.plan.to_s + " / " + self.materium.to_s
  end

  
end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000

