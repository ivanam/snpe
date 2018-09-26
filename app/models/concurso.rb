class Concurso < ActiveRecord::Base

	def es_activo
		current = DateTime.current
		result = (self.fecha_inicio < current) and (self.fecha_fin >= current)
		return result
	end


end
