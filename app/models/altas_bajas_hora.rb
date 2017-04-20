class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :lote_impresion
  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'altas_bajas_hora_id', dependent: :destroy
  has_many :estados, :class_name => 'AltasBajasHoraEstado', :foreign_key => 'alta_baja_hora_id', dependent: :destroy
  belongs_to :empresa
  belongs_to :lugar_pago
  belongs_to :materium
  belongs_to :plan

  validates_presence_of :persona

  #Validates from Silvio Andres "CHEQUEAR"
  validates :fecha_alta, :presence => true
  validates :situacion_revista, :presence => true
  validates :horas, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  #validates :ciclo_carrera, length: { minimum: 1, maximum: 4}, numericality: { only_integer: true }#, allow_blank: true
  validates :anio, length: { minimum: 1, maximum: 2}, :numericality => { :greater_than_or_equal_to => 0, :message => "Ingrese un número entre 0 y 6" }
  validates :division, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :persona_id, :presence => true
  validates :plan_id, :presence => true
  validates :materium_id, :presence => true
  #validates :turno, :presence => true

  #Validación de alta
  #validate :validar_alta


  #Validates de persona en AltasBajas
  #validates :persona_id,:nro_documento, presence: true
  #validates :persona_id,:nombres, :presence => true
  #validates :person_id,:apellidos, presence: true
  #validates :person_id,:cuil, presence: true, length: { is: 11 }, numericality: { only_integer: true }

  #validates :nro_documento, presence: true
  #validates :nombres, presence: true
  #validates :apellidos, presence: true
  #validates :cuil, presence: true, length: { is: 11 }, numericality: { only_integer: true }
  before_save :actualizar_materia
  before_update :dar_baja

  #-------------------------------------

  ANIO = ["0","1","2","3","4","5","6"]
  ESTADOS = ["ALT","BAJ","LIC"]  
  LONGITUD_CODIGO = 4

  #Método que valida el alta de un paquete de horas
  def validar_alta 
    establecimiento = Establecimiento.find(id: self.establecimiento_id)
    nivel = establecimiento.nivel
    if nivel.descripcion = "Superior"
      #Obtengo el despliegue correspondiente a la materia y el plan
      despliegue = Despliegue.where(plan_id: self.plan_id, materium_id: self.materium_id).first            
      #Cantidad de registros
      @cantidad_registros = AltasBajasHora.where(:establecimiento_id => self.establecimiento_id, division: self.division, turno: self.turno, anio: self.anio, plan_id: self.plan_id, materium_id: self.materium_id).count
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

  def estado_actual
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).last
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

  #Revisar!!!
  def actualizar_materia    
    if self.materium_id == nil || self.materium_id == '' || self.materium_id == 0
      self.materium_id = Materium.where(codigo: self.codificacion).first.id
    end
  end
end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000

