class Asistencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :cargo
  belongs_to :cargo_no_docente
  
  #Creo que la asistencia debe tener su propio campo en sí mismo, ya que el registro de asistencias es mensual. Por lo cual esto no iria.
  has_many :periodos, :class_name => 'PeriodoAsistencia', :foreign_key => 'asistencia_id', dependent: :destroy

  has_many :altas_bajas_horas, class_name: "AltasBajasHora", foreign_key: "altas_bajas_hora_id"

  has_many :alta_cargos, class_name: "Cargo", foreign_key: "altas_bajas_cargo_id"

  has_many :alta_cargo_no_docentes, class_name: "CargoNoDocente", foreign_key: "altas_bajas_cargo_no_docente_id"

  attr_default :ina_justificada, 0
  attr_default :ina_injustificada, 0
  attr_default :lleg_tarde_justificada, 0
  attr_default :lleg_tarde_injustificada, 0


  def estado_actual
    @relation = AsistenciaEstado.where(:asistencia_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_anterior
    @relation = AsistenciaEstado.where(:asistencia_id => self.id).last
    @relation = AsistenciaEstado.where(:asistencia_id => self.id).where.not(id: @relation.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

end
