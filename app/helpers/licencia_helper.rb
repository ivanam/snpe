module LicenciaHelper

	def cargos_persona_permitida(dni) #funcion de busqueda para licencias
		@cargos_persona = Cargo.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento])
		if current_user.role? :escuela then
			@cargos_persona_fecha = @cargos_persona.where(:establecimiento_id => session[:establecimiento])
	    end 	
	    return @cargos_persona
	end
  
	def cargos_no_docente_persona_permitida(dni)
		@cargos_persona_aux = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento])
		if current_user.role? :escuela then
			@cargos_persona_aux_fecha = @cargos_persona_aux.where(:establecimiento_id => session[:establecimiento]) 
	    end 	
	    return @cargos_persona_aux
	end

	def horas_persona_permitida(dni)
		@horas_persona = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento]).includes(:establecimiento, :materium)  
		if current_user.role? :escuela then
			@horas_persona_fecha = @horas_persona.where(:establecimiento_id => session[:establecimiento])
    	end
    	return @horas_persona
	end

	def licencias(dni)
		if current_user.role? :personal then
			@licencia_cargo=Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
			@licencia_cargos_no_docentes=Licencium.where(:cargo_no_docente_id => CargoNoDocente.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    		@licencia_horas=Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    	else
    		@licencia_cargo=Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])).where(:establecimiento_id => session[:establecimiento])).map(&:id)
    		@licencia_cargos_no_docentes=Licencium.where(:cargo_no_docente_id => CargoNoDocente.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])).where(:establecimiento_id => session[:establecimiento])).map(&:id)
    		@licencia_horas=Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])).where(:establecimiento_id => session[:establecimiento])).map(&:id)
    	end 
    	@licencia_cargo.each do |l|
      		@licencia_horas.push(l)
    	end 
    	@licencia_cargos_no_docentes.each do |l|
      		@licencia_horas.push(l)
    	end    	
     	return Licencium.where(:id => @licencia_horas)
	end

	def listado_de_licencias(mindate, maxdate)		
		if current_user.role? :personal or current_user.role? :sadmin then			
			return Licencium.select('establecimientos.*, personas.*, licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate)
		else
			return Licencium.select('establecimientos.*, personas.*, licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]})
		end
	end
	def listado_de_licencias_cargo		
		return Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id')
	end 
	def listado_de_licencias_cargonds		
		return Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id')
	end  	
end