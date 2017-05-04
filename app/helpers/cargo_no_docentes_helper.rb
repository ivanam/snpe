module CargoNoDocentesHelper
	def cargo_no_docentes_nuevos_permitidos(mindate, maxdate)
	  @cargo_no_docentes = CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	  @cargo_no_docentes_ids = []
	  @cargo_no_docentes.each do |c|
	    if c.estado_actual == "Ingresado" || c.estado_actual == "Cancelado"
	      @cargo_no_docentes_ids << c.id
	    end
	  end
	  #AltasBajasHoraEstado.where()
	  return CargoNoDocente.where(:id => @cargo_no_docentes_ids).includes(:persona)
	end

	def cargo_no_docentes_notificados_permitidos(mindate, maxdate)
	  @cargo_no_docentes = CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	  @cargo_no_docentes_ids = []
	  @cargo_no_docentes.each do |c|
	    if c.estado_actual == "Notificado" || c.estado_actual == "Chequeado" || c.estado_actual == "Impreso"
	      @cargo_no_docentes_ids << c.id
	    end
	  end
	  return CargoNoDocente.where(:id => @cargo_no_docentes_ids).includes(:persona)
	end

	def cargo_no_docentes_novedades_permitidas(mindate, maxdate)
	  @cargo_no_docentes = CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where('fecha_alta >= ?', mindate).where('fecha_alta <= ?', maxdate)
	  @cargo_no_docentes_ids = []
	  @cargo_no_docentes.each do |a|
	    if a.estado_actual == "Chequeado" || a.estado_actual == "Impreso"
	      @cargo_no_docentes_ids << a.id
	    end
	  end
	  @cargo_no_docentes = CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate)
	  @cargo_no_docentes.each do |a|
	    if a.estado_actual == "Impreso" || a.estado_actual == "Chequeado_Baja"
	      @cargo_no_docentes_ids << a.id
	    end
	  end
	  return CargoNoDocente.where(:id => @cargo_no_docentes_ids).includes(:persona)
	end

	def cargo_no_docentes_bajas_efectivas_permitidas(mindate, maxdate)
	    @cargo_no_docentes = CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where.not(:fecha_baja => "").where('fecha_baja >= ?', mindate).where('fecha_baja <= ?', maxdate)
	    @cargo_no_docentes_ids = []
	    @cargo_no_docentes.each do |c|
	      if c.estado_actual == "Chequeado_Baja" || c.estado_actual == "Impreso" || c.estado_actual == "Notificado_Baja"
	        @cargo_no_docentes_ids << c.id
	      end
	    end
	    return CargoNoDocente.where(:id => @cargo_no_docentes_ids).includes(:establecimiento, :persona)
  	end

   	def cargo_no_docentes_bajas_permitidas
      return CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).where("fecha_baja = '0000-00-00' or fecha_baja is null").includes(:establecimiento, :persona)
    end


  	 def cargo_no_docentes_modificacion
       return CargoNoDocente.where(:establecimiento_id => session[:establecimiento]).includes(:establecimiento, :persona)
  	end

end
