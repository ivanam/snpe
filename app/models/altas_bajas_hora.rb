class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :lote_impresion
  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'altas_bajas_hora_id', dependent: :destroy
  has_many :estados, :class_name => 'AltasBajasHoraEstado', :foreign_key => 'alta_baja_hora_id', dependent: :destroy
  belongs_to :empresa

  validates_presence_of :persona

  #Validates from Silvio Andres "CHEQUEAR"
  validates :fecha_alta, presence: true
  #validates :situacion_revista, presence: true
  validates :horas, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :ciclo_carrera, length: { minimum: 1, maximum: 4}, numericality: { only_integer: true }#, allow_blank: true
  validates :anio, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :division, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  #validates :codificacion, length: { minimum: 1, maximum: 4}, numericality: { only_integer: true }#, allow_blank: true
  validates :persona_id, :presence => true
  validates :plan_id, :presence => true
  validates :materia_id, :presence => true

  #Validates de persona en AltasBajas
  #validates :persona_id,:nro_documento, presence: true
  #validates :persona_id,:nombres, :presence => true
  #validates :person_id,:apellidos, presence: true
  #validates :person_id,:cuil, presence: true, length: { is: 11 }, numericality: { only_integer: true }

  #validates :nro_documento, presence: true
  #validates :nombres, presence: true
  #validates :apellidos, presence: true
  #validates :cuil, presence: true, length: { is: 11 }, numericality: { only_integer: true }

  #-------------------------------------

  TURNO = ["M", "T", "M/T", "JC", "V", "N"]
  ANIO = ["0","1","2","3","4","5","6"]
  LONGITUD_CODIGO = 4

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
end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000

