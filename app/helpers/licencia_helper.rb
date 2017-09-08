module LicenciaHelper

	def cargos_persona_permitida(dni) #funcion de busqueda para licencias

		if current_user.role? :escuela then
      cargo_ids = Cargo.joins(:persona).where(personas: {nro_documento: dni}, :establecimiento_id => session[:establecimiento]).where("(estado = 'ALT' or estado = 'LIC')").map(&:id)
    else 
			cargo_ids = Cargo.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC')").map(&:id)
    end
    cargo_lic = Licencium.where(cargo_id: cargo_ids, vigente: "Vigente").map(&:cargo_id)
    return Cargo.where(id: cargo_ids).where.not(id: cargo_lic)
	end
  
	def cargos_no_docente_persona_permitida(dni)
		if current_user.role? :escuela then
			cargo_nd_ids = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, :establecimiento_id => session[:establecimiento]).where("(estado = 'ALT' or estado = 'LIC')")
    else
			cargo_nd_ids = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC')")
    end
    cargo_nd_lic = Licencium.where(cargo_no_docente_id: cargo_nd_ids, vigente: "Vigente").map(&:cargo_no_docente_id)
    return CargoNoDocente.where(id: cargo_nd_ids).where.not(id: cargo_nd_lic).includes(:establecimiento)
	end

	def horas_persona_permitida(dni)
		if current_user.role? :escuela then
			hora_ids = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}, :establecimiento_id => session[:establecimiento]).where("(estado = 'ALT' or estado = 'LIC')").map(&:id) #.includes(:establecimiento, :materium)  
		else
			hora_ids = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC')").map(&:id) #.includes(:establecimiento, :materium)  
    end
    hora_lic = Licencium.where(altas_bajas_hora_id: hora_ids, vigente: "Vigente").map(&:altas_bajas_hora_id)
    return AltasBajasHora.where(id: hora_ids).where.not(id: hora_lic).includes(:establecimiento, :materium)
	end

	def licencias(dni)
		if current_user.role? :personal or current_user.role? :licencia  then
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
		if current_user.role? :personal or current_user.role? :sadmin or current_user.role? :licencia then			
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate)
			#Licencium.joins(:articulo).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where('articulo_id in (2,3,4,5)')
		else			
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*').from('licencia, altas_bajas_horas, establecimientos, personas').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id').where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate).where('fecha_hasta <= ?', maxdate).where('articulo_id in (242,243,244,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		end	

		return @licencias
	end

 #    def listado_de_licencias_todas(mindate4, maxdate4)		
	# 	if current_user.role? :personal or current_user.role? :sadmin  or current_user.role? :licencia then
	# 		@licenciasT = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, altas_bajas_horas.*').from('licencia, cargos, establecimientos, personas, altas_bajas_horas').where('(licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id) OR (licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id)').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4))

	# 		# Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4).where('codigo in ("25","29","45","31e","13","24","36","28", "27e")')
			
	# 	else			
	# 		# @licenciasT = Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4).where(:id => session[:establecimiento])
	# 	end	

	# 	return @licenciasT
	# end

	def listado_de_licencias_cargo(mindate3, maxdate3)
		if current_user.role? :personal or current_user.role? :sadmin or current_user.role? :licencia then			
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id').where('fecha_desde >= ?', mindate3).where('fecha_hasta <= ?', maxdate3).where('articulo_id in (242,243,244,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
        else
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*').from('licencia, cargos, establecimientos, personas').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id').where('fecha_desde >= ?', mindate3).where('fecha_hasta <= ?', maxdate3).where(cargos: {establecimiento_id: session[:establecimiento]}).where('articulo_id in (242,243,244,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
        end

		return @licenciasCarg
	end 
	
	def listado_de_licencias_cargonds(mindate2, maxdate2)
		if current_user.role? :personal or current_user.role? :sadmin or current_user.role? :licencia then			
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate2).where('fecha_hasta <= ?', maxdate2).where('articulo_id in (242,243,244,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		else
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('fecha_hasta <= ?', maxdate2).where('articulo_id in (242,243,244,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		end
		return @licenciasCnds
        #Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate2).where('fecha_hasta >= ?', maxdate2)
	end	
end