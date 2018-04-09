class Despliegue < ActiveRecord::Base
  belongs_to :plan
  belongs_to :materium


  validates :carga_horaria, length: { minimum: 1, maximum: 2}, numericality: { :greater_than => 0, :message => "Ingrese un número mayor a 0" }
  validates :carga_horaria, length: { minimum: 1, maximum: 2}, numericality: { :greater_than => 0, :message => "Ingrese un número mayor a 0" }
  validates :fecha_alta, :presence => true
end

