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
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where('articulo_id in (242,243,244,245)')
			#Licencium.joins(:articulo).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where('articulo_id in (2,3,4,5)')
		else			
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where('articulo_id in (242,243,244,245)')
		end	

		return @licencias
	end

    def listado_de_licencias_todas(mindate4, maxdate4)		
		if current_user.role? :personal or current_user.role? :sadmin then
			@licenciasT = Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4)
			
		else			
			@licenciasT = Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4).where(:id => session[:establecimiento])
		end	

		return @licenciasT
	end

	def listado_de_licencias_cargo(mindate3, maxdate3)
		if current_user.role? :personal or current_user.role? :sadmin then			
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id').where('fecha_desde >= ?', mindate3).where('fecha_hasta <= ?', maxdate3).where('articulo_id in (242,243,244,245)')
        else
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id').where('fecha_desde >= ?', mindate3).where('fecha_hasta <= ?', maxdate3).where(cargos: {establecimiento_id: session[:establecimiento]}).where('articulo_id in (242,243,244,245)')
        end

		return @licenciasCarg
	end 
	
	def listado_de_licencias_cargonds(mindate2, maxdate2)
		if current_user.role? :personal or current_user.role? :sadmin then			
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate2).where('fecha_hasta <= ?', maxdate2).where('articulo_id in (242,243,244,245)')
		else
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('fecha_hasta <= ?', maxdate2).where('articulo_id in (242,243,244,245)')
		end
		return @licenciasCnds
        #Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate2).where('fecha_hasta >= ?', maxdate2)
	end  	
end