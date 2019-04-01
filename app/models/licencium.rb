class Licencium < ActiveRecord::Base
  belongs_to :altas_bajas_hora
  belongs_to :cargo
  belongs_to :cargo_no_docente
  belongs_to :articulo
  belongs_to :user
  belongs_to :establecimiento_destino, :class_name => 'Establecimiento', :foreign_key => 'destino'
  has_many :licenciasV

  before_create :actualizar_estado
  before_update :ponerle_fecha
  before_update :cancelar_licencia

  #validate :fecha_inicio_valida
  #validate :superposicion_fechas

  validate :fecha_hasta_mayor_fecha_desde

  validate :validaAnioLic
 
  ESTABLECIMIENTOS = [4001,4007,5009,567,4000,4004,4009,4012,4014,4015,4016,4017,4018,3000,3031,4002,4006,9000]

  def self.corregir_licencia_hora_con_goce
  	con_goce = Articulo.where(con_goce: true).map(&:id)
  	licencias_hora = Licencium.where(vigente: "Vigente", articulo_id: con_goce).where.not(altas_bajas_hora_id: nil).map(&:altas_bajas_hora_id)
  	AltasBajasHora.where(id: licencias_hora, estado: "ALT").each do |hora|
  		hora.update(estado: "ART")
  	end
  end

  def self.corregir_licencias_cargo_con_goce
  	con_goce = Articulo.where(con_goce: true).map(&:id)
  	licencias_cargo = Licencium.where(vigente: "Vigente", articulo_id: con_goce).where.not(cargo_id: nil).map(&:cargo_id)
  	Cargo.where(id: licencias_cargo, estado: "ALT").each do |cargo|
  		cargo.update(estado: "ART")
  	end
  end



 def ash_id
 	return self.altas_bajas_hora_id
 end

 def c_id
 
 	return self.cargo_id
 end

 def ponerle_fecha
 	self.fecha_creacion = Date.today.to_s
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

 def validaAnioLic
 	if ((self.articulo_id == 289 or self.articulo_id == 241) && (self.anio_lic == nil))
 		errors.add(:base, "La fecha del año a la que corresponde la licencia no puede estar vacia")
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

 	# def superposicion_fechas
 	# 	if self.fecha_hasta != nil
	 # 		Licencium.where(cargo_id: self.cargo_id, altas_bajas_hora_id: self.altas_bajas_hora_id, cargo_no_docente_id: cargo_no_docente_id).where.not(id: self.id).where.not(vigente: "Cancelada").each do |l|
	 # 			if (l.fecha_desde == self.fecha_desde) || (l.fecha_hasta == self.fecha_desde)
	 # 				return errors.add(:fecha_hasta, "La licencia se superpone")
	 # 			elsif (l.fecha_desde == self.fecha_hasta) || (l.fecha_hasta == self.fecha_hasta)
	 # 				return errors.add(:fecha_hasta, "La licencia se superpone")
	 # 			elsif (l.fecha_desde < self.fecha_desde) && (self.fecha_desde < l.fecha_hasta)
	 # 				return errors.add(:fecha_hasta, "La licencia se superpone")
	 # 			elsif (l.fecha_desde < self.fecha_hasta) && (self.fecha_hasta < l.fecha_hasta)
	 # 				return errors.add(:fecha_hasta, "La licencia se superpone")
	 # 			end
	 # 		end
	 # 	end
 		
 	# end

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
 			if self.fecha_hasta != nil

	 			if self.fecha_desde > self.fecha_hasta
	 				errors.add(:fecha_desde, "No puede ser menor a la fecha de finalización")
	 			end
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
	 					AltasBajasHoraEstado.create(alta_baja_hora_id: alta_horas.id, estado_id: 7, user_id: 1)
	 				end
	 			elsif Establecimiento.find(AltasBajasHora.find(self.altas_bajas_hora_id).establecimiento_id).sede
	 				alta_horas.update!(estado: 'ALT')
	 			elsif self.por_continua != nil

        elsif alta_horas.plan_id !=113 && alta_horas.plan_id !=249
	 				suplentes_activos = AltasBajasHora.where(materium_id: alta_horas.materium_id ,plan_id: alta_horas.plan_id, anio: alta_horas.anio, turno: alta_horas.turno, division: alta_horas.division, establecimiento_id: alta_horas.establecimiento_id).where(" fecha_alta > '" +  alta_horas.fecha_alta.to_time.iso8601 + "'" ).where.not(estado: "BAJ").where.not(estado: "LIC P/BAJ").where.not(id: alta_horas.id)
					if suplentes_activos == []
            if alta_horas.estado != 'BAJ'
		 				 alta_horas.update!(estado: 'ALT')
            end
		 			else
		 				errors.add(:base, "No se puede dar de baja, existen suplentes activos")
		 				return false
		 			end
        else
          alta_horas.update!(estado: 'ALT')
		 		end

            
	 		elsif self.cargo_id != nil
	 			cargo = Cargo.find(self.cargo_id)
	 			if self.por_baja
	 				if cargo.update!(estado: 'BAJ', fecha_baja: self.fecha_hasta )
	 					CargoEstado.create(cargo_id: cargo.id, estado_id: 7, user_id: 1)
	 				end
	 		    elsif self.por_continua != nil
	 			elsif (Establecimiento.find(Cargo.find(self.cargo_id).establecimiento_id).sede == nil)
	 				cargo.update!(estado: 'ALT')
        elsif Cargo.find(self.cargo_id).trabaja_en_sede != nil or (Establecimiento.find(Cargo.find(self.cargo_id).establecimiento_id).sede != nil)
          cargo.update!(estado: 'ALT')
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
