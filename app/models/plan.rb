class Plan < ActiveRecord::Base

  has_many :establecimientos_plans, :foreign_key => 'plan_id', :class_name => 'EstablecimientoPlan'
  has_many :establecimientos, :through => :establecimientos_plans 
  accepts_nested_attributes_for :establecimientos_plans, allow_destroy: true
  has_many :despliegues


  validates :resolucion, :presence => true
  validates :nivel_id, :presence => true
  validates :tipo_plan_id, :presence => true
  validates :descripcion, :presence => true
  
	def to_s
		"#{ self.codigo } - #{self.descripcion}"
	end
end
