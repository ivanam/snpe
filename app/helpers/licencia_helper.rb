module LicenciaHelper

  def horas_persona(dni)
    hora_ids = AltasBajasHora.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC' or estado = 'ART')").map(&:id)
    return AltasBajasHora.where(id: hora_ids).includes(:establecimiento)
  end


  def cargos_persona(dni) #funcion de busqueda para licencias

    cargo_ids = Cargo.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC' or estado = 'ART')").map(&:id)
    return Cargo.where(id: cargo_ids).includes(:establecimiento)
  end

  def cargos_no_docentes_persona(dni)
    cargo_nd_ids = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}).where("(estado = 'ALT' or estado = 'LIC' or estado = 'ART')")
    return CargoNoDocente.where(id: cargo_nd_ids).includes(:establecimiento)
  end


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
			cargo_nd_ids = CargoNoDocente.joins(:persona).where(personas: {nro_documento: dni}, :establecimiento_id => session[:establecimiento].to_i).where("(estado = 'ALT' or estado = 'LIC')")
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
		if current_user.role? :personal or current_user.role? :licencia then
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

    def listado_de_licencias_todas(mindate4, maxdate4)		
		if current_user.role? :personal or current_user.role? :sadmin or current_user.role? :licencia then
			@licenciasT = Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4).where('codigo in ("25","29","45","31e","23","24","36","36","28","27e")')
		else			
			@licenciasT = Licenciasv.select('*').from('licenciasvs').where('fecha_desde >= ?', mindate4).where('fecha_hasta <= ?', maxdate4).where(:id => session[:establecimiento]).where('codigo in ("25","29","45","31e","23","24","36","36","28","27e")')
		end	

		return @licenciasT
	end
  

	def listado_de_licencias(mindate, maxdate)	
		if current_user.role? :personal or current_user.role? :sadmin then  
		    @licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*, articulos.*, licencia.observaciones').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('DATE(licencia.created_at) = ?', mindate).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		elsif current_user.role? :licencia 		
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*, articulos.* , licencia.observaciones').from('licencia, altas_bajas_horas, establecimientos, personas , articulos').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('licencia.vigente in ("Vigente")').where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes)
		else			
			@licencias = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*, articulos.* , licencia.observaciones').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).where('DATE(licencia.created_at) = ?', mindate).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		end	

		return @licencias
	end

	def listado_de_licencias_cargo(mindate3, maxdate3)
		if current_user.role? :personal or current_user.role? :sadmin then			
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, articulos.*, licencia.observaciones').from('licencia, cargos, establecimientos, personas, articulos').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id  AND licencia.articulo_id = articulos.id').where('DATE(licencia.created_at) = ?', mindate3).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
        elsif current_user.role? :licencia 
            @licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, articulos.* , licencia.observaciones').from('licencia, cargos, establecimientos, personas, articulos').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id  AND licencia.articulo_id = articulos.id').where('licencia.vigente in ("Vigente")').where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes)   
        else	
        	@licenciasCarg = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, articulos.* , licencia.observaciones').from('licencia, cargos, establecimientos, personas, articulos').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id  AND licencia.articulo_id = articulos.id').where('DATE(licencia.created_at) = ?', mindate3).where(cargos: {establecimiento_id: session[:establecimiento]}).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
        end

		return @licenciasCarg
	end 
	
	def listado_de_licencias_cargonds(mindate2, maxdate2)
		if current_user.role? :personal or current_user.role? :sadmin then			
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*, articulos.* , licencia.observaciones').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('DATE(licencia.created_at) = ?', maxdate2).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		elsif current_user.role? :licencia
		   @licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*, articulos.*, licencia.observaciones').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('licencia.vigente in ("Vigente")').where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes)
		else	
			@licenciasCnds = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*, articulos.*, licencia.observaciones').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('DATE(licencia.created_at) = ?', mindate2).where('articulo_id in (242,243,245,291,292,293,294,263,264,265,266,299,300,321,322,323,324,325)')
		end
		return @licenciasCnds
        #Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*').from('licencia, cargo_no_docentes, establecimientos, personas').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id').where('fecha_desde >= ?', mindate2).where('fecha_hasta >= ?', maxdate2)
	end


	def listado_parte_diario(mindate, maxdate)


		if current_user.role? :licencia		
			@licenciasH = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*, articulos.* , licencia.observaciones').from('licencia, altas_bajas_horas, establecimientos, personas , articulos').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('articulo_id in (242,243,245,291,292,294,263,264,265,266,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes).where('licencia.vigente = "Vigente"')
		    @liceCN = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, articulos.* , licencia.observaciones').from('licencia, cargos, establecimientos, personas, articulos').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id  AND licencia.articulo_id = articulos.id').where('articulo_id in (242,243,245,291,292,294,263,264,265,266,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes).where('licencia.vigente = "Vigente"')  
		    @licenciasC = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*, articulos.*, licencia.observaciones').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('articulo_id in (242,243,245,291,292,294,263,264,265,266,300,321,322,323,324,325)').where('establecimientos.codigo_jurisdiccional in ' + Establecimiento.estab_sedes).where('licencia.vigente = "Vigente"')
		    @licencias = @licenciasH + @liceCN + @licenciasC 

		elsif current_user.role? :personal or current_user.role? :sadmin  or current_user.role? :escuela then  
			@licenciasH = Licencium.select('establecimientos.*, personas.*, licencia.*, altas_bajas_horas.*, articulos.* , licencia.observaciones').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).where('articulos.medico = 1').where('licencia.vigente = "Vigente"')
			@liceCN = Licencium.select('establecimientos.*, personas.*, licencia.*, cargo_no_docentes.*, articulos.*, licencia.observaciones').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('articulos.medico = 1').where('licencia.vigente = "Vigente"')
      @licenciasC = Licencium.select('establecimientos.*, personas.*, licencia.*, cargos.*, articulos.* , licencia.observaciones').from('licencia, cargos, establecimientos, personas, articulos').where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id  AND licencia.articulo_id = articulos.id').where(cargos: {establecimiento_id: session[:establecimiento]}).where('articulos.medico = 1').where('licencia.vigente = "Vigente"')

			@licencias = @licenciasH + @liceCN + @licenciasC 

		end	

		return @licencias
	end
 #---------------------------------licencias sin goce ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	def listado_de_licencias_sg(mindate, maxdate, dni, art)		
		if current_user.role? :personal or current_user.role? :sadmin  or current_user.role? :licencia then
		    if  dni == nil and  art == nil	
				@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
				where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
				where('licencia.updated_at >= ?', mindate).
				where('licencia.updated_at <= ?', maxdate).
				where('articulos.con_goce = 0').
				where('vigente not in ("Cancelada")')
			end
			if dni != nil and  art == nil
            	@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
            	where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('licencia.updated_at >= ?', mindate).
            	where('licencia.updated_at <= ?', maxdate).
            	where('articulos.con_goce = 0').
            	where('nro_documento= ?', dni).
            	where('vigente not in ("Cancelada")')
            end
            if dni == nil and art != nil
            	@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
            	where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('licencia.updated_at >= ?', mindate).
            	where('licencia.updated_at <= ?', maxdate).
            	where('articulo_id = ?', art).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		    if  dni != nil and art != nil
            	@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
            	where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('licencia.updated_at >= ?', mindate).
            	where('licencia.updated_at <= ?', maxdate).
            	where('articulo_id = ?', art).
            	where('nro_documento= ?', dni).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		else
			 if  dni == nil and  art == nil	
				@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
				where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
				where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).
				where('licencia.updated_at >= ?', mindate).
				where('articulos.con_goce = 0').
				where('vigente not in ("Cancelada")').
				where('articulos.con_goce = 0')
			end
			if dni != nil and  art == nil
	            @licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
	            where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
	            where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).
	            where('licencia.updated_at >= ?', mindate).
	            where('articulos.con_goce = 0').
	            where('nro_documento= ?', dni).
	            where('vigente not in ("Cancelada")').
	            where('articulos.con_goce = 0')
            end
            if dni == nil and art != nil
            	@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
            	where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).
            	where('licencia.updated_at >= ?', mindate).
            	where('articulo_id = ?', art).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		    if  dni != nil and art != nil
            	@licenciasSg = Licencium.select('licencia.*').from('licencia, altas_bajas_horas, establecimientos, personas, articulos').
            	where('licencia.altas_bajas_hora_id = altas_bajas_horas.id AND altas_bajas_horas.establecimiento_id = establecimientos.id AND altas_bajas_horas.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where(altas_bajas_horas: {establecimiento_id: session[:establecimiento]}).
            	where('licencia.updated_at >= ?', mindate).
            	where('articulo_id = ?', art).
            	where('nro_documento= ?', dni).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		end
		return @licenciasSg
	end

	def listado_de_licencias_cargo_sg(mindate3, maxdate3, dni3, art3)
		if current_user.role? :personal or current_user.role? :sadmin  or current_user.role? :licencia then
		    if  dni3 == nil and  art3 == nil	
				@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
				where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
				where('fecha_desde >= ?', mindate3).
				where('articulos.con_goce = 0').
				where('vigente not in ("Cancelada")').
				where('articulos.con_goce = 0').
				where('articulos.con_goce = 0')
			end
			if dni3 != nil and  art3 == nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('fecha_desde >= ?', mindate3).
            	where('articulos.con_goce = 0').
            	where('nro_documento= ?', dni3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
            end
            if dni3 == nil and art3 != nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('fecha_desde >= ?', mindate3).
            	where('articulo_id = ?', art3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0').
            	where('articulos.con_goce = 0')
		    end
		    if  dni3 != nil and art3 != nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where('fecha_desde >= ?', mindate3).
            	where('articulo_id = ?', art3).
            	where('nro_documento= ?', dni3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		else
			if  dni3 == nil and  art3 == nil	
				@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
				where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
				where(cargos: {establecimiento_id: session[:establecimiento]}).
				where('fecha_desde >= ?', mindate3).
				where('articulos.con_goce = 0').
				where('vigente not in ("Cancelada")').
				where('articulos.con_goce = 0')
			end
			if dni3 != nil and  art3 == nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where(cargos: {establecimiento_id: session[:establecimiento]}).
            	where('fecha_desde >= ?', mindate3).
            	where('articulos.con_goce = 0').
            	where('nro_documento= ?', dni3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
            end
            if dni3 == nil and art3 != nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where(cargos: {establecimiento_id: session[:establecimiento]}).
            	where('fecha_desde >= ?', mindate3).
            	where('articulo_id = ?', art3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		    if  dni3 != nil and art3 != nil
            	@licenciasCargSg = Licencium.select('licencia.*').from('licencia, cargos, establecimientos, personas, articulos').
            	where('licencia.cargo_id = cargos.id AND cargos.establecimiento_id = establecimientos.id AND cargos.persona_id = personas.id AND licencia.articulo_id = articulos.id').
            	where(cargos: {establecimiento_id: session[:establecimiento]}).
            	where('fecha_desde >= ?', mindate3).
            	where('articulo_id = ?', art3).
            	where('nro_documento= ?', dni3).
            	where('vigente not in ("Cancelada")').
            	where('articulos.con_goce = 0')
		    end
		end
		return @licenciasCargSg
	end
	


	def listado_de_licencias_cargonds_sg(mindate2, maxdate2, dni2, art2)
		if current_user.role? :personal or current_user.role? :sadmin  or current_user.role? :licencia then
		    if  dni2 == nil and  art2 == nil	
			@licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('fecha_desde >= ?', mindate2).where('articulos.con_goce = 0').where('vigente not in ("Cancelada")')
			end
			if dni2 != nil and  art2 == nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('fecha_desde >= ?', mindate2).where('articulos.con_goce = 0').where('nro_documento= ?', dni2).where('vigente not in ("Cancelada")')
            end
            if dni2 == nil and art2 != nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos ').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('fecha_desde >= ?', mindate2).where('articulo_id = ?', art2).where('vigente not in ("Cancelada")')
		    end
		    if  dni2 != nil and art2 != nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where('fecha_desde >= ?', mindate2).where('articulo_id = ?', art2).where('nro_documento= ?', dni2).where('vigente not in ("Cancelada")')
		    end
		else
			if  dni2 == nil and  art2 == nil	
			@licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('con_goce = 0').where('vigente not in ("Cancelada")')
			end
			if dni2 != nil and  art2 == nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('con_goce = 0').where('nro_documento= ?', dni2).where('vigente not in ("Cancelada")')
            end
            if dni2 == nil and art2 != nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('articulo_id = ?', art2).where('vigente not in ("Cancelada")')
		    end
		    if  dni2 != nil and art2 != nil
            @licenciasCndsSg = Licencium.select('licencia.*').from('licencia, cargo_no_docentes, establecimientos, personas, articulos').where('licencia.cargo_no_docente_id = cargo_no_docentes.id AND cargo_no_docentes.establecimiento_id = establecimientos.id AND cargo_no_docentes.persona_id = personas.id AND licencia.articulo_id = articulos.id').where(cargo_no_docentes: {establecimiento_id: session[:establecimiento]}).where('fecha_desde >= ?', mindate2).where('articulo_id = ?', art2).where('nro_documento= ?', dni2).where('vigente not in ("Cancelada")')
		    end	
	end
		return @licenciasCndsSg
	end

  def historico_licencias_agente(mindate, maxdate, dni, art, id,tipo)
    
    if tipo == "horas"
    	@licencias = Licencium.select('l.*').from('licencia l, altas_bajas_horas h').where('l.altas_bajas_hora_id= h.id').where('l.altas_bajas_hora_id = ?', id).where('articulo_id = ?', art).where('fecha_desde >= ?', mindate).where('vigente != ("Cancelada")')
    elsif tipo == "cargos"
      @licencias = Licencium.select('l.*').from('licencia l, cargos h').where('l.cargo_id= h.id').where('l.cargo_id = ?', id).where('articulo_id = ?', art).where('fecha_desde >= ?', mindate).where('vigente != ("Cancelada")')
    elsif tipo == "auxiliar"
      @licencias = Licencium.select('l.*').from('licencia l, cargo_no_docentes h').where('l.cargo_no_docente_id= h.id').where('l.cargo_no_docente_id = ?', id).where('articulo_id = ?', art).where('fecha_desde >= ?', mindate).where('vigente != ("Cancelada")')
    end
      return @licencias
  end
end


