class CargoInscripDoc < ActiveRecord::Base
  belongs_to :inscripcion
  has_many :cargo
  has_many :nivel
  has_many :persona
  #has_many :cargo_no_docente
end
