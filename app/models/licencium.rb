class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :cargo
  belongs_to :cargo_no_docente
  belongs_to :articulo
  belongs_to :establecimiento_destino, :class_name => 'Establecimiento', :foreign_key => 'destino'
  has_many :licenciasV

  before_create :actualizar_estado
  before_update :cancelar_licencia

  #validate :fecha_inicio_valida
 
 def ash_id
 
 	return self.altas_bajas_hora_id
 end

 def c_id
 
 	return self.cargo_id
 end

 private
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
	 				alta_horas.update!(estado: 'BAJ', fecha_baja: self.fecha_hasta )
	 			elsif self.por_continua != nil
                elsif  alta_horas.plan_id ==113 or alta_horas.plan_id ==249  	 
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
	 				cargo.update!(estado: 'BAJ', fecha_baja: self.fecha_hasta )
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
