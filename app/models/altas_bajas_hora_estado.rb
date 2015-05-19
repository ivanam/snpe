class AltasBajasHoraEstado < ActiveRecord::Base
  belongs_to :alta_baja_hora
  belongs_to :estado
end
