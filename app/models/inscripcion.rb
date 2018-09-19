class Inscripcion < ActiveRecord::Base
  belongs_to :persona
  belongs_to :region

  has_many :cargo_inscrip_doc, :foreign_key => 'inscripcion_id', :class_name => 'CargoInscripDoc'
  accepts_nested_attributes_for :cargo_inscrip_doc, allow_destroy: true

  validates :persona, :presence => true, uniqueness: { message: "Ya existe una inscripcion para el docente." }
  validates :region, :presence => true
  validates :fecha_incripcion, :presence => true
  validates :cabecera, :presence => true
  validates :cargo_inscrip_doc, presence: { message: "Debe agregar al menos un cargo" }
  
end