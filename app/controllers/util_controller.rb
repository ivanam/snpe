class UtilController < ApplicationController
  autocomplete :persona, :apeynom, :full => false, :extra_data => [:apeynom, :nro_documento], :display_value => :to_s

  def buscar_persona    
    @persona = Persona.where(:nro_documento => params[:dni]).first()
    render json: @persona
  end


  def get_autocomplete_items(parameters)
    if (current_user.role? :escuela) || (current_user.role? :delegacion) then
      establecimiento_id = session[:establecimiento]
      horas = Persona.joins(:altas_bajas_hora).where('(nro_documento like "%' + params[:term] + '%" or apeynom like "%' + params[:term] + '%") AND altas_bajas_horas.estado != "BAJ" AND altas_bajas_horas.establecimiento_id = '+establecimiento_id.to_s).distinct
      cargos = Persona.joins(:cargo).where('(nro_documento like "%' + params[:term] + '%" or apeynom like "%' + params[:term] + '%") AND cargos.estado != "BAJ" AND cargos.establecimiento_id = '+establecimiento_id.to_s).distinct
      cargos_no_docentes = Persona.joins(:cargo_no_docente).where('(nro_documento like "%' + params[:term] + '%" or apeynom like "%' + params[:term] + '%") AND cargo_no_docentes.estado != "BAJ" AND cargo_no_docentes.establecimiento_id = '+establecimiento_id.to_s).distinct
      resultado = horas | cargos | cargos_no_docentes      
      return resultado
    else      
      return Persona.where('apellidos like "%' + parameters[:term] + '%" or nombres like "%' + parameters[:term] + '%" or nro_documento like "%' + parameters[:term] + '%" or apeynom like "%' + parameters[:term] + '%"')
    end
  end


  def buscar_hora
    @horas = AltasBajasHora.joins(:persona).merge(Persona.where(:nro_documento => params[:dni]))
    render json: @horas
  end

  def buscar_persona_por_id
    @persona = Persona.where(:id => params[:id]).first()
    render json: @persona
  end

  def buscar_estados_altas_bajas_hora
  	@estados = AltasBajasHoraEstado.where(:alta_baja_hora_id => params[:id])
  	@observaciones = Array.new
  	@estados.all.each do |e|
  		@estado = Estado.find(e.estado_id).descripcion.to_s
      @cadena = '<tr class="limpiable"><td>'+Util.fecha_a_es(e.created_at.to_date)+'</td><td>'+'<span class="label label-'+e.color_estado+'">'+ e.mensaje_estado + '</span></td><td>' + e.observaciones.to_s+'</td></tr>'      
  		@observaciones << @cadena
  	end
    render json: @observaciones
  end

  def buscar_estados_cargo
    @estados = CargoEstado.where(:cargo_id => params[:id])
    @observaciones = Array.new
    @estados.all.each do |e|
      @estado = Estado.find(e.estado_id).descripcion.to_s
      @cadena = '<tr class="limpiable"><td>'+Util.fecha_a_es(e.created_at.to_date)+'</td><td>'+'<span class="label label-'+e.color_estado+'">'+ e.mensaje_estado + '</span></td><td>' + e.observaciones.to_s+'</td></tr>'      
      @observaciones << @cadena
    end
    render json: @observaciones
  end

  def buscar_estados_cargo_no_docente
    @estados = CargoNoDocenteEstado.where(:cargo_no_docente_id => params[:id])
    @observaciones = Array.new
    @estados.all.each do |e|
      @estado = Estado.find(e.estado_id).descripcion.to_s
      @cadena = '<tr class="limpiable"><td>'+Util.fecha_a_es(e.created_at.to_date)+'</td><td>'+'<span class="label label-'+e.color_estado+'">'+ e.mensaje_estado + '</span></td><td>' + e.observaciones.to_s+'</td></tr>'      
      @observaciones << @cadena
    end
    render json: @observaciones
  end

  def buscar_materias_plan
    @materias_ids = Despliegue.where(:plan_id => params[:plan_id], :anio => params[:anio]).map(&:materium_id)
    @materias_permitidas = Materium.where(:id => @materias_ids)

    render json: @materias_permitidas
  end

  def buscar_carga_horaria_materia
    @despliegue = Despliegue.where(:materium_id => params[:materium_id], :plan_id => params[:plan_id], :anio => params[:anio]).first
    render json: @despliegue.carga_horaria
  end
end