class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  has_many :periodos, :class_name => 'PeriodoLiqHora', :foreign_key => 'altas_bajas_hora_id', dependent: :destroy

  #Validates from Silvio Andres "CHEQUEAR"
  validates :establecimiento_id, :fecha_alta, presence: true
  validates_format_of :situacion_revista, with: /\A(\d{1})-(\d{3})\Z/#, allow_blank: true
  validates :horas, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :ciclo_carrera, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :anio, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :division, length: { minimum: 1, maximum: 2}, numericality: { only_integer: true }#, allow_blank: true
  validates :codificacion, length: { is: 4}, numericality: { only_integer: true }#, allow_blank: true
  #-------------------------------------

  TURNO = ["M", "T"]

  def ina_justificada(periodo)
    @asistencia = Asistencium.where(:altas_bajas_hora_id => self.id).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_justificada.to_s
    end
  end

  def ina_injustificada(periodo)
    @asistencia = Asistencium.where(:altas_bajas_hora_id => self.id).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.ina_injustificada.to_s
    end
  end

  def lleg_tarde_justificada(periodo)
    @asistencia = Asistencium.where(:altas_bajas_hora_id => self.id).first
    if @asistencia == nil
      return "0"
    else
      return @asistencia.lleg_tarde_justificada.to_s
    end
  end

  def lleg_tarde_injustificada(periodo)
    @asistencia = Asistencium.where(:altas_bajas_hora_id => self.id).first
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

  def estado_actual
    @relation = AltasBajasHoraEstado.where(:alta_baja_hora_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

end

#SELECT * FROM detalle d inner join recibos r on r.nume_docu = d.nume_docu where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
#SELECT * FROM detalle d where d.nume_docu = 30284359 and d.mes = 4 and d.anio = 2015 LIMIT 0,1000
# TRAER CARGOS ACTIVOS DE UNA PERSONA SELECT * FROM paddoc p where nume_docu = 30284359 and estado = "ALT" LIMIT 0,1000

