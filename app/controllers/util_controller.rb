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
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-danger">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  		elsif @estado == "Chequeado" then
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-success">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  	    elsif @estado == "Notificado" then
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-success">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  	    elsif @estado == "Ingresado" then
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-warning">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
  		else
  			@cadena = '<div class="limpiable" style="padding: 5px;"><span class="label label-primary">'+@estado + ' - ' + e.observaciones.to_s + ' - ' + Util.fecha_a_es(e.created_at.to_date)+'</span></div>'
        end
  		@observaciones << @cadena
  	end
    render json: @observaciones
  end

end