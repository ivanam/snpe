class Inscripcion < ActiveRecord::Base
  has_many :rubro
  belongs_to :persona
  belongs_to :establecimiento
  has_many :funcion
  has_many :nivel
  has_many :cargo

  has_many :titulo_personas, :foreign_key => 'persona_id', :class_name => 'TituloPersona'
  has_many :titulos, :through => :titulo_personas 
  accepts_nested_attributes_for :titulo_personas, allow_destroy: true

end