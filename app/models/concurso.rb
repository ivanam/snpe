class Concurso < ActiveRecord::Base
  	validate :validar_rango_fechas, :validar_unico_concurso_activo, :validar_fechas_futuras
	
	def es_activo
		current = DateTime.current
		result = (self.fecha_inicio < current) and (self.fecha_fin >= current)
		return result
	end

	def validar_unico_concurso_activo
		existe = false
		ini = self.fecha_inicio
		fin = self.fecha_fin
		Concurso.all.each do |concurso|
			if (self.fecha_inicio <= concurso.fecha_fin && self.fecha_fin >= concurso.fecha_inicio)
				errors.add(:base, "Ya se existe concurso habilitado para la fecha.")
				break
			end 
		end 
  	end

  	def validar_rango_fechas
  		ini = self.fecha_inicio
		fin = self.fecha_fin
		diff = fin - ini
		if (diff <= 0) and (DateTime.new(diff).day <= 1)
			errors.add(:base, "Ingrese rango de fechas validos.")
		end
  	end

  	def validar_fechas_futuras
  		hoy = DateTime.current
  		ini = self.fecha_inicio
  		if ini > hoy
			errors.add(:base, "Fecha de comienzo debe ser mayor a la fecha actual.")
  		end
		
  	end 

end
