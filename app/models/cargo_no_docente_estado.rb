class CargoNoDocenteEstado < ActiveRecord::Base
  belongs_to :cargo_no_docente
  belongs_to :estado
end
