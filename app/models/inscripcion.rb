class Inscripcion < ActiveRecord::Base
  has_many :rubro
  belongs_to :persona
  belongs_to :establecimiento
  has_many :funcion
  has_many :nivel
  has_many :cargo
end