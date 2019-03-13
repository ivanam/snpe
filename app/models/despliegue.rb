class Despliegue < ActiveRecord::Base
  belongs_to :plan
  belongs_to :materium

  validates_uniqueness_of :plan_id, :scope => [:materium_id, :anio, :carga_horaria], message: "Despliegue repetido"


  validates :cant_docentes, length: { minimum: 1, maximum: 2}, numericality: { :greater_than => 0, :message => "Ingrese un número mayor a 0" }
  validates :carga_horaria, length: { minimum: 1, maximum: 2}, numericality: { :greater_than => 0, :message => "Ingrese un número mayor a 0" }
  validates :anio, :presence => true
end

