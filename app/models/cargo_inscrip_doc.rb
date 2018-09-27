class CargoInscripDoc < ActiveRecord::Base
  belongs_to :inscripcion
  belongs_to :funcion

 # validates :inscripcion, :presence => true
  validates :funcion, :presence => true
  validates :opcion, :presence => true

end
