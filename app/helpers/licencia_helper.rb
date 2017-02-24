module LicenciaHelper

	def cargos_persona_permitida(dni)
		@cargos_persona = Cargo.joins(:persona).merge(Persona.where(:nro_documento => dni))
		if current_user.role? :personal then
			@cargos_persona_fecha = @cargos_persona.where(:establecimiento_id => session[:establecimiento]) #.where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	    else
	    	@cargos_persona_fecha = @cargos_persona.all
	    end 	
	    @licencia_cargos = Licencium.where(:cargo_id => @cargos_persona_fecha, :vigente => "Vigente").map(&:cargo_id)
	    return @cargos_persona.where.not(:id => @licencia_cargos)
	end

	def horas_persona_permitida(dni)
		@horas_persona = AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => dni))
		if current_user.role? :personal then
			@horas_persona_fecha = @horas_persona.where(:establecimiento_id => session[:establecimiento]) #.where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
    	else
    		@horas_persona_fecha = @horas_persona.all
    	end
    	@licencia_horas = Licencium.where(:altas_bajas_hora_id => @horas_persona_fecha, :vigente => "Vigente").map(&:altas_bajas_hora_id)
    	return @horas_persona.where.not(:id => @licencia_horas)
	end

	def licencias(dni)
		if current_user.role? :personal then
			@licencia_cargo=Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    		@licencia_horas=Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))).map(&:id)
    	else
    		@licencia_cargo=Licencium.where(:cargo_id => Cargo.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])).where(:establecimiento_id => session[:establecimiento])).map(&:id)
    		@licencia_horas=Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni])).where(:establecimiento_id => session[:establecimiento])).map(&:id)
    	end 
    	@licencia_cargo.each do |l|
      		@licencia_horas.push(l)
    	end 
     	return Licencium.where(:id => @licencia_horas)
	end

	def licencias		
		return Licencium.where(:altas_bajas_hora_id => AltasBajasHora.joins(:persona, :establecimiento))
		#return Licencium.joins("INNER JOIN altas_bajas_hora ON licencia.altas_bajas_hora_id = altas_bajas_hora.id").includes(:persona,:establecimiento)
	end 	
end