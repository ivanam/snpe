class CargoInscripDoc < ActiveRecord::Base
  belongs_to :inscripcion
  belongs_to :juntafuncion


 # validates :inscripcion, :presence => true
  validates :juntafuncion, :presence => true
  validates :opcion, :presence => true

  HUMANIZED_ATTRIBUTES = {
    :juntafuncion => "Cargo",
    :opcion => "Prioridad"    
  }

  def self.human_attribute_name(attr, options = {}) # 'options' wasn't available in Rails 3, and prior versions.
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

end
