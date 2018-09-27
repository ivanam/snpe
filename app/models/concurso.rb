class Concurso < ActiveRecord::Base
  	validate :un_solo_concurso_activo,
	
	def es_activo
		current = DateTime.current
		result = (self.fecha_inicio < current) and (self.fecha_fin >= current)
		return result
	end

	def un_solo_concurso_activo
		existe = false
		ini = self.fecha_inicio
		fin = self.fecha_fin
		Concurso.all.each do |concurso|
			if (self.fecha_inicio <= concurso.fecha_fin && self.fecha_fin >= concurso.fecha_inicio)
				errors.add(:base, "Interposicion de fechas")
				break
			end 
		end 
  	end

end
