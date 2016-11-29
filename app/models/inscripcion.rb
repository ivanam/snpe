class Inscripcion < ActiveRecord::Base
  has_many :rubro
  belongs_to :persona
  belongs_to :establecimiento
  has_many :funcion
  has_many :nivel
  has_many :cargo

  
  has_many :titulo_persona, :foreign_key => 'persona_id', :class_name => 'TituloPersona'
  has_many :titulos, :through => :titulo_persona 
  accepts_nested_attributes_for :titulo_persona, allow_destroy: true

  has_many :cargo_inscrip_doc, :foreign_key => 'inscripcion_id', :class_name => 'CargoInscripDoc'
  has_many :funcion, :through => :cargo_inscrip_doc 
  accepts_nested_attributes_for :cargo_inscrip_doc, allow_destroy: true

end