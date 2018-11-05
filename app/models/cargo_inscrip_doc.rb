class CargoInscripDoc < ActiveRecord::Base
  belongs_to :inscripcion
  belongs_to :juntafuncion


 # validates :inscripcion, :presence => true
  validates :juntafuncion, :presence => true
  validates :opcion, :presence => true

end
