class Asistencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo
  
  #Creo que la asistencia debe tener su propio campo en sí mismo, ya que el registro de asistencias es mensual. Por lo cual esto no iria.
  has_many :periodos, :class_name => 'PeriodoAsistencia', :foreign_key => 'asistencia_id', dependent: :destroy

  attr_default :ina_justificada, 0
  attr_default :ina_injustificada, 0
  attr_default :lleg_tarde_justificada, 0
  attr_default :lleg_tarde_injustificada, 0

end
