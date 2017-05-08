module LicenciaHelper

	def cargos_persona_permitida(dni) #funcion de busqueda para licencias
		if current_user.role? :escuela then
			return Cargo.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento])
	    else 
			return Cargo.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT')	    	
	    end
	end
  
	def cargos_no_docente_persona_permitida(dni)
		if current_user.role? :escuela then
			return CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento]).includes(:establecimiento)
	    else
			return CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT').includes(:establecimiento)
	    end	
	end

	def horas_persona_permitida(dni)
		if current_user.role? :escuela then
			return AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento]).includes(:establecimiento, :materium)  
		else
			return AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT').includes(:establecimiento, :materium)  
    	end
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
			@licencias = Licencium.joins(:articulo).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate)
		else			
			@licencia_cargo=Licencium.joins(:cargo).where(cargos: {:establecimiento_id => session[:establecimiento]}).map(&:id)
    		@licencia_cargos_no_docentes=Licencium.joins(:cargo_no_docente).where(cargo_no_docentes: {:establecimiento_id => session[:establecimiento]}).map(&:id)
    		@licencia_horas=Licencium.joins(:altas_bajas_hora).where(altas_bajas_horas: {:establecimiento_id => session[:establecimiento]}).map(&:id)

			@licencia_cargo.each do |l|
				@licencia_horas.push(l)
			end
			@licencia_cargos_no_docentes.each do |l|
				@licencia_horas.push(l)
			end

            @licencias = Licencium.joins(:articulo).where(:id => @licencia_horas).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate)
		end	

		return @licencias
	end
	def listado_de_licencias_cargo(mindate, maxdate)
		return Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta >= ?', maxdate).where(cargos: {establecimiento_id: session[:establecimiento]})
	end 
	def listado_de_licencias_cargonds(mindate, maxdate)
		return Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta >= ?', maxdate).where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]})
	end  	
end