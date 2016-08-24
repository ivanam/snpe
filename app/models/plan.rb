class Plan < ActiveRecord::Base
	def to_s
		"#{ self.codigo } - #{self.descripcion}"
	end
end
