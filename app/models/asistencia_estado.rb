class AsistenciaEstado < ActiveRecord::Base
  belongs_to :asistencia
  belongs_to :estado
  belongs_to :user
end
