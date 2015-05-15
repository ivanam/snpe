class Asistencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo
end
