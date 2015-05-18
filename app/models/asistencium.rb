class Asistencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo


  attr_default :ina_justificada, 0
  attr_default :ina_injustificada, 0
  attr_default :lleg_tarde_justificada, 0
  attr_default :lleg_tarde_injustificada, 0
end
