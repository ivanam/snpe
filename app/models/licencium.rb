class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :cargo
  belongs_to :cargo_no_docente
  belongs_to :articulo
  belongs_to :user
  belongs_to :establecimiento_destino, :class_name => 'Establecimiento', :foreign_key => 'destino'
  has_many :licenciasV

  before_create :actualizar_estado
  before_update :cancelar_licencia

  #validate :fecha_inicio_valida
  validate :superposicion_fechas

  validate :fecha_hasta_mayor_fecha_desde
 

 def ash_id
 	return self.altas_bajas_hora_id
 end

 def c_id
 
 	return self.cargo_id
 end

 def agente
 	if self.altas_bajas_hora_id != nil
 		return self.altas_bajas_hora.persona.to_s
 	elsif self.cargo_id != nil
 		return self.cargo.persona.to_s
 	elsif self.cargo_no_docente_id != nil 				
 		return self.cargo_no_docente.persona.to_s
 	end
 end

 def secuencia
 	if self.altas_bajas_hora_id != nil
 		return self.altas_bajas_hora.secuencia
 	elsif self.cargo_id != nil
 		return self.cargo.secuencia
 	elsif self.cargo_no_docente_id != nil 				
 		return self.cargo_no_docente.secuencia
 	end
 end

 def descripcion
 	if self.altas_bajas_hora_id != nil
 		return "Horas " + self.altas_bajas_hora.horas.to_s + " - " + self.altas_bajas_hora.plan_materia
 	elsif self.cargo_id != nil
 		return Funcion.where(categoria: self.cargo.cargo).first.to_s
 	elsif self.cargo_no_docente_id != nil 				
 		return self.cargo_no_docente.secuencia
 	end
 end

 def curso
 	if self.altas_bajas_hora_id != nil
 		return self.altas_bajas_hora.anio.to_s + " - " + self.altas_bajas_hora.division.to_s
 	elsif self.cargo_id != nil
 		return self.cargo.anio.to_s + " - " + self.cargo.division.to_s
 	elsif self.cargo_no_docente_id != nil 				
 		return self.cargo_no_docente.secuencia
 	end
 end

 def establecimiento
 	if self.altas_bajas_hora_id != nil
 		return self.altas_bajas_hora.establecimiento.codigo_jurisdiccional.to_s
 	elsif self.cargo_id != nil
 		return self.cargo.establecimiento.codigo_jurisdiccional.to_s
 	elsif self.cargo_no_docente_id != nil 				
 		return self.cargo_no_docente.establecimiento.codigo_jurisdiccional.to_s
 	end
 end

 private

 	def superposicion_fechas

 		Licencium.where(cargo_id: self.cargo_id, altas_bajas_hora_id: self.altas_bajas_hora_id, cargo_no_docente_id: cargo_no_docente_id).where.not(id: self.id).each do |l|
 			if (l.fecha_desde == self.fecha_desde) || (l.fecha_hasta == self.fecha_desde)
 				return errors.add(:fecha_hasta, "La licencia se superpone")
 			elsif (l.fecha_desde == self.fecha_hasta) || (l.fecha_hasta == self.fecha_hasta)
 				return errors.add(:fecha_hasta, "La licencia se superpone")
 			elsif (l.fecha_desde < self.fecha_desde) && (self.fecha_desde < l.fecha_hasta)
 				return errors.add(:fecha_hasta, "La licencia se superpone")
 			elsif (l.fecha_desde < self.fecha_hasta) && (self.fecha_hasta < l.fecha_hasta)
 				return errors.add(:fecha_hasta, "La licencia se superpone")
 			end
 		end
 		
 	end

 		def fecha_inicio_valida
 			fecha_alta = nil
 			if self.altas_bajas_hora_id != nil
 				fecha_alta = self.altas_bajas_hora.fecha_alta
 			elsif self.cargo_id != nil
 				fecha_alta = self.cargo.fecha_alta
 			elsif self.cargo_no_docente_id != nil 				
 				fecha_alta = self.cargo_no_docente.fecha_alta
 			end
 			if self.fecha_desde.to_date < fecha_alta.to_date
 				errors.add(:fecha_desde, "No puede ser menor a la fecha de alta")
 			end
 			if self.fecha_desde.to_date > fecha_hasta.to_date
 				errors.add(:fecha_desde, "No puede ser menor a la fecha de alta")
 			end
 		end

 		def fecha_hasta_mayor_fecha_desde
 			if self.fecha_desde > self.fecha_hasta
 				errors.add(:fecha_desde, "No puede ser menor a la fecha de finalización")
 			end
 		end

	 	def actualizar_estado
			if self.articulo.con_goce
				estado = 'ART' #Cuando la licencia no debe ser informada a Economía
			else 
				estado = 'LIC' 		
			end
			if self.altas_bajas_hora_id != nil
				AltasBajasHora.find(self.altas_bajas_hora_id).update!(estado: estado)
			elsif self.cargo_id != nil
				Cargo.find(self.cargo_id).update!(estado: estado)
			elsif self.cargo_no_docente_id != nil
				CargoNoDocente.find(self.cargo_no_docente_id).update(estado: estado)
			    # CargoNoDocente.find(self.cargo_no_docente_id).attributes = params[:estado]
				# CargoNoDocente.find(self.cargo_no_docente_id).save(:validate => false)
			end
	 end  
     

	 def cancelar_licencia
	 	if (self.vigente == "Cancelada") || (self.vigente == "Finalizada")
	 		if self.altas_bajas_hora_id != nil
	 			alta_horas = AltasBajasHora.find(self.altas_bajas_hora_id)
	 		
	 			if self.por_baja
	 				if alta_horas.update!(estado: 'BAJ', fecha_baja: self.fecha_hasta )
	 					AltasBajasHoraEstado.create(alta_baja_hora_id: alta_horas.id, estado: 7)
	 				end
	 			elsif self.por_continua != nil
        		elsif alta_horas.plan_id ==113 or alta_horas.plan_id ==249
	 				suplentes_activos = AltasBajasHora.where(materium_id: alta_horas.materium_id ,plan_id: alta_horas.plan_id, anio: alta_horas.anio, turno: alta_horas.turno, division: alta_horas.division, establecimiento_id: alta_horas.establecimiento_id).where(" fecha_alta > '" +  alta_horas.fecha_alta.to_s + "'" ).where.not(estado: "BAJ").where.not(estado: "LIC P/BAJ").where.not(id: alta_horas.id)
					if suplentes_activos == []
		 				alta_horas.update!(estado: 'ALT')
		 			else
		 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
		 				return false
		 			end



	 			else
		 			suplentes_activos = AltasBajasHora.where(materium_id: alta_horas.materium_id ,plan_id: alta_horas.plan_id, anio: alta_horas.anio, turno: alta_horas.turno, division: alta_horas.division, establecimiento_id: alta_horas.establecimiento_id).where(" fecha_alta > '" +  alta_horas.fecha_alta.to_s + "'" ).where.not(estado: "BAJ").where.not(estado: "LIC P/BAJ").where.not(id: alta_horas.id)
					if suplentes_activos == []
		 				alta_horas.update!(estado: 'ALT')
		 			else
		 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
		 				return false
		 			end
		 		end

            
	 		elsif self.cargo_id != nil
	 			cargo = Cargo.find(self.cargo_id)
	 			if self.por_baja
	 				if cargo.update!(estado: 'BAJ', fecha_baja: self.fecha_hasta )
	 					CargoEstado.create(cargo_id: cargo.id, estado: 7)
	 				end

	 			elsif self.por_continua != nil 


	 			else
		 			suplentes_activos = Cargo.where(cargo: cargo.cargo, turno: cargo.turno, anio: cargo.anio, anio: cargo.anio, division: cargo.division, establecimiento_id: cargo.establecimiento_id, grupo_id: cargo.grupo_id).where.not(estado: "BAJ").where.not(estado: "LIC P/BAJ").where(" fecha_alta > '" +  cargo.fecha_alta.to_s + "'")
		 			
		 			if suplentes_activos == []
		 				cargo.update!(estado: 'ALT')
		 			else
		 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
		 				return false
		 			end
		 		end


	 		elsif self.cargo_no_docente_id != nil
	 			
	 			if self.por_continua != nil 

	 			elsif self.por_continua == nil 
	 				
	 				CargoNoDocente.find(self.cargo_no_docente_id).update(estado: 'ALT')
	 			end
	 		end
		end
	 end 
end
