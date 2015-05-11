class AltasBajasHora < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona

  TURNO = ["M", "T"]

end
