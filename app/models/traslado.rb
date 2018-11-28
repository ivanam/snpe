class Traslado < ActiveRecord::Base
	belongs_to :cargo
	belongs_to :altas_bajas_hora
	belongs_to :cargo_no_docente
	belongs_to :user


	def get_persona
		if !self.cargo.nil?
			return cargo.persona
		elsif !self.altas_bajas_hora.nil?
			return self.altas_bajas_hora.persona
		elsif !self.cargo_no_docente.nil?
			self.cargo_no_docente.persona
		end
	end

	def get_secuencia
		if !self.cargo.nil?
			return cargo.secuencia
		elsif !self.altas_bajas_hora.nil?
			return self.altas_bajas_hora.secuencia
		elsif !self.cargo_no_docente.nil?
			self.cargo_no_docente.secuencia
		end		
	end

	def get_tipo_cargo
		if !self.cargo.nil?
			return "Cargo"
		elsif !self.altas_bajas_hora.nil?
			return "Cargo no Docente"
		elsif !self.cargo_no_docente.nil?
			return "Horas"
		end
	end

	def get_establecimiento
		if !self.cargo.nil?
			return self.cargo.establecimiento
		elsif !self.altas_bajas_hora.nil?
			return self.altas_bajas_hora.establecimiento
		elsif !self.cargo_no_docente.nil?
			return self.cargo_no_docente.establecimiento
		end
	end

end
