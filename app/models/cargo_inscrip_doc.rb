class CargoInscripDoc < ActiveRecord::Base
  belongs_to :inscripcion
  has_many :cargo
  has_many :nivel
  belongs_to :persona
  has_many :cargosnds
end
