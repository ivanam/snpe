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
    validates :plan_id, :presence => true, if: :no_es_licencia_para_baja
    validates :materium_id, :presence => true, if: :no_es_licencia_para_baja
    validates :turno, :presence => true, if: :no_es_licencia_para_baja

  # # #Validación de alta
    before_create :validar_horas
    validate :validar_alta 
    before_save :actualizar_materia
    before_update :dar_baja
    before_create :control_horas
  end


  #-------------------------------------

  ANIO = ["0","1","2","3","4","5","6","7","8","9"]
  PLANES_SIN_VALIDACION = [122, 3000] #Listado de planes que no requieren validacion
  LONGITUD_CODIGO = 4

  def control_horas
    if !PLANES_SIN_VALIDACION.include?(Plan.find(self.plan_id).codigo)
      self.horas = Despliegue.where(plan_id: self.plan_id, materium_id: self.materium_id, anio: self.anio).first.carga_horaria
    end
  end

  def no_es_licencia_para_baja
    self.estado != "LIC P/BAJ"
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
      if validar_situacion_revista
        if plan_con_validacion
          validar_titular
          validar_interino
          validar_reemplazante
          validar_suplente
        end
      end      
    end
  end

  def validar_horas
    if Despliegue.where(:materium_id => self.materium_id, :plan_id => self.plan_id, :anio => self.anio, :carga_horaria => self.horas ).first == nil

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
        return false
      end
    end
    return true
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
    establecimiento = Establecimiento.find(id: self.establecimiento_id)
    nivel = establecimiento.nivel
    if nivel.descripcion = "Superior"
      #Obtengo el despliegue correspondiente a la materia y el plan
      despliegue = Despliegue.where(plan_id: self.plan_id, materium_id: self.materium_id).first            
      #Cantidad de registros
      cantidad_registros = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).count
      if !(despliegue.cantidad_docentes < cantidad_registros)
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
    if self.id.to_i == 14936
      debugger      
    end
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

