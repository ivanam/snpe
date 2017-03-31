module LicenciaHelper

	def cargos_persona_permitida(dni)
		@cargos_persona = Cargo.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento])
		if current_user.role? :escuela then
			@cargos_persona_fecha = @cargos_persona.where(:establecimiento_id => session[:establecimiento], estado: 'ALT') #.where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	    else
	    	@cargos_persona_fecha = @cargos_persona.where(estado: 'ALT')
	    end 	
	    #Vigente ya no seria necesario por controlar estado = 'ALT'
	    @licencia_cargos = Licencium.where(:cargo_id => @cargos_persona_fecha, :vigente => "Vigente").map(&:cargo_id)
	    return @cargos_persona.where.not(:id => @licencia_cargos)
	end

	def cargos_no_docente_persona_permitida(dni)
		@cargos_persona_aux = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento])
		if current_user.role? :escuela then
			@cargos_persona_aux_fecha = @cargos_persona_aux.where(:establecimiento_id => session[:establecimiento], estado: 'ALT') #.where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	    else
	    	@cargos_persona_aux_fecha = @cargos_persona_aux.where(estado: 'ALT')
	    end 	
	    #Vigente ya no seria necesario por controlar estado = 'ALT'
	    @licencia_cargos_no_docentes = Licencium.where(:cargo_no_docente_id => @cargos_persona_aux_fecha, :vigente => "Vigente").map(&:cargo_no_docente_id)
	    return @cargos_persona_aux.where.not(:id => @licencia_cargos_no_docentes)
	end

	def horas_persona_permitida(dni)
		@horas_persona = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}, estado: 'ALT', :establecimiento_id => session[:establecimiento]).includes(:establecimiento, :materium)  
		if current_user.role? :escuela then
			@horas_persona_fecha = @horas_persona.where(:establecimiento_id => session[:establecimiento], estado: 'ALT')
    	else
    		@horas_persona_fecha = @horas_persona.where(estado: 'ALT')
    	end
    	#Vigente ya no seria necesario por controlar estado = 'ALT'
    	@licencia_horas = Licencium.where(:altas_bajas_hora_id => @horas_persona_fecha, :vigente => "Vigente").map(&:altas_bajas_hora_id)
    	return @horas_persona.where.not(:id => @licencia_horas)
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

	def listado_de_licencias		
		return Licencium.select('establecimientos.*, personas.*, licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id')
	end 	
end