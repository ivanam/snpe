class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :altas_bajas_cargo
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
	 		AltasBajasHora.find(self.altas_bajas_hora_id).update!(estado: estado)
	 	elsif self.cargo_id != nil
	 		Cargo.find(self.cargo_id).update!(estado: estado)
	 	elsif self.cargo_no_docente_id != nil
	 		CargoNoDocente.find(self.cargo_no_docente_id).update(estado: estado)
	 	end
	 end  

	 def cancelar_licencia
	 	if self.vigente == "Cancelada"
	 		if self.altas_bajas_hora_id != nil

	 			AltasBajasHora.find(self.altas_bajas_hora_id).update(estado: 'ALT')

	 		elsif self.cargo_id != nil
	 			cargo = Cargo.find(self.cargo_id)
	 			suplentes_activos = Cargo.where(cargo: cargo.cargo, turno: cargo.turno, anio: cargo.anio, curso: cargo.curso, division: cargo.division, establecimiento_id: cargo.establecimiento_id).where.not(estado: "BAJ").where(" id > " +  cargo.id.to_s )
	 			if suplentes_activos == []
	 				cargo.update!(estado: 'ALT')
	 			else
	 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
	 				return false
	 			end

	 		elsif self.cargo_no_docente_id != nil

	 			CargoNoDocente.find(self.cargo_no_docente_id).update(estado: 'ALT')

	 		end
		end
	 end 
end
