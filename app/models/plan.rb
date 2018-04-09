class Plan < ActiveRecord::Base

  has_many :despliegues
  
	def to_s
		"#{ self.codigo } - #{self.descripcion}"
	end
end
