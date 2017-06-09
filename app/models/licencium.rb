class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :cargo
  belongs_to :cargo_no_docente
  belongs_to :articulo
  has_many :licenciasV

  before_create :actualizar_estado
  before_update :cancelar_licencia
 
 def ash_id
 
 	return self.altas_bajas_hora_id
 end

 def c_id
 
 	return self.cargo_id
 end

 private

	 def actualizar_estado
	 	if self.articulo.con_goce
	 		estado = 'ART' #Cuando la licencia no debe ser informada a Economía
	 	else 
			estado = 'LIC' 		
	 	end
	 	if self.altas_bajas_hora_id != nil
	 		AltasBajasHora.find(self.altas_bajas_hora_id).update(estado: estado)
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
	 				alta_horas.update!(fecha_baja: self.fecha_hasta)
	 			else
		 			suplentes_activos = AltasBajasHora.where(materium_id: alta_horas.materium_id ,plan_id: alta_horas.plan_id, anio: alta_horas.anio, turno: alta_horas.turno, division: alta_horas.division, establecimiento_id: alta_horas.establecimiento_id).where.not(estado: "BAJ").where(" id > " +  alta_horas.id.to_s )
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
	 				cargo.update!(estado: "BLI")
	 			else
		 			suplentes_activos = Cargo.where(cargo: cargo.cargo, turno: cargo.turno, anio: cargo.anio, anio: cargo.anio, division: cargo.division, establecimiento_id: cargo.establecimiento_id, grupo_id: cargo.grupo_id).where.not(estado: "BAJ").where(" fecha_alta > '" +  cargo.fecha_alta.to_s + "'")
		 			debugger
		 			if suplentes_activos == []
		 				cargo.update!(estado: 'ALT')
		 			else
		 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
		 				return false
		 			end
		 		end

	 		elsif self.cargo_no_docente_id != nil
	 			CargoNoDocente.find(self.cargo_no_docente_id).update(estado: 'ALT')
	 		end
		end
	 end 
end
