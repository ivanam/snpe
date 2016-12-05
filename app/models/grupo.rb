class Grupo < ActiveRecord::Base
	def to_s
		"#{ self.nombre } - #{ self.descripcion }"
	end
end
