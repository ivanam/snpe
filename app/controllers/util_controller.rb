class UtilController < ApplicationController

  def buscar_persona
    @persona = Persona.where(:nro_documento => params[:dni]).first()
    render json: @persona
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
  		if @estado == "Cancelado" then
  		  if Role.where(:id => (UserRole.where(:user_id => e.user_id).first.role_id)).first.description == "personal" then
  		    @estado = "Cancelado por personal"  			
  		  elsif Role.where(:id => (UserRole.where(:user_id => e.user_id).first.role_id)).first.description == "escuela" then
  		  	@estado = "Cancelado por escuela"
  		  end
  		  @cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-danger">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'  		  	
  		elsif @estado == "Chequeado" then
  		  if Role.where(:id => (UserRole.where(:user_id => e.user_id).first.role_id)).first.description == "personal" then
  		    @estado = "Chequeado por personal" 
  		  end
  		  @cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-success">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  	    elsif @estado == "Notificado" then
  		  @estado = "Notificado por escuela"
  		  @cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-success">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  	    elsif @estado == "Ingresado" then
  		  @estado = "Ingresado por escuela"
  		  @cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-warning">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  		else
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-primary">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
        end
  		@observaciones << @cadena
  	end
    render json: @observaciones
  end

end