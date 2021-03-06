class Concurso < ActiveRecord::Base
  	validate :validar_rango_fechas, 
  		:validar_unico_concurso_activo, 
  		:validar_fechas_futuras,
  		:validar_fecha_concurso
	
	has_many :inscripcions

	def to_s
  		"#{ self.descripcion }"
  	end

  	def self.get_concurso_activo
  		Concurso.all.each do |concurso|
			if concurso.es_activo
				return concurso
			end 
		end
		return nil
	end

	def es_activo
		current = DateTime.current
		ini = self.fecha_inicio
		fin = self.fecha_fin
		result = (ini < current) && (fin >= current)
		return result
	end

	def validar_unico_concurso_activo
		existe = false
		ini = self.fecha_inicio
		fin = self.fecha_fin
		Concurso.all.each do |concurso|
			if (concurso.id != self.id and
				self.fecha_inicio <= concurso.fecha_fin && self.fecha_fin >= concurso.fecha_inicio)
				errors.add(:base, "Ya se existe concurso habilitado para la fecha.")
				break
			end 
		end 
  	end

  	def validar_rango_fechas
  		ini = self.fecha_inicio
		fin = self.fecha_fin
		if ini >= fin || (fin - ini).to_i < 1
			errors.add(:base, "Ingrese rango de fechas validos.")
		end
  	end

  	def validar_fechas_futuras
  		if not self.created_at.nil?
  			creacion = self.created_at.to_date
  		else
  			creacion = Date.current
  		end
  		ini = self.fecha_inicio.to_date
  		if ini < creacion
			errors.add(:base, "Fecha de comienzo debe ser mayor o igual a la fecha actual.")
  		end		
  	end 

  	def validar_fecha_concurso
  		if self.fecha_fin > self.fecha_concurso
  			errors.add(:base, "Fecha de concurso es anterior al cierre de inscripciones.")
  		end
  	end

end
