class AltasBajasHoraEstado < ActiveRecord::Base
  belongs_to :alta_baja_hora
  belongs_to :estado
   

  #validate :control_baja


  def control_baja
    if self.estado_id == 7 
      if self.alta_baja_hora.estado = 'BAJ'
        errors.add(:estado, "no corresponde")
      end
    end
  end

   def mensaje_estado
     @estado = Estado.where(:id => self.estado_id).first.descripcion.to_s
     if @estado == "Cancelado" then
       @resultado = "Cancelado por " + User.find(self.user_id).email
     
     elsif @estado == "Chequeado" then
       @resultado = "Chequeado por " + User.find(self.user_id).email
     
     elsif @estado == "Ingresado" then
       @resultado = "Ingresado por " + User.find(self.user_id).email
    
     elsif @estado == "Notificado" then
       @resultado = "Notificado por " + User.find(self.user_id).email
    
     elsif @estado == "Impreso" then
        @resultado = "Impreso"
        if (AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id != nil) || (AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id != nil) then
          if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id).count > 0) then 
            if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión" 
            end
          elsif (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id).count > 0) then
            if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión"
            end
          end
        end 
        bajaloteid = AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id.to_s 
        altaloteid = AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id.to_s
        estadoAlBaj = AltasBajasHora.where(:id => self.alta_baja_hora_id).first.estado.to_s       
        if bajaloteid == nil || bajaloteid == ""
          @resultado = "El alta Impresa en codigo N° " + altaloteid
        elsif  bajaloteid != nil || estadoAlBaj == "BAJ"
          if altaloteid == nil || altaloteid == ""
            @resultado = "Baja Impresa en N° " + bajaloteid
          else 
            @resultadoAlt = "Alta Impresa en N° " + altaloteid
            @resultadoBaj = ", Baja Impresa en N° " + bajaloteid
            @resultado = @resultadoAlt + @resultadoBaj
          end
        elsif bajaloteid!= nil || estadoAlBaj == "ALT"
          @resultado = "Alta Impresa"
          @resultado = "Alta Impresa en N° " + altaloteid
        end
          
     elsif @estado == "Notificado_Baja" then
       @resultado = "Baja notificada por " + User.find(self.user_id).email
     
     elsif @estado == "Cancelado_Baja" then
       @resultado = "Baja cancelada por " + User.find(self.user_id).email
     
     elsif @estado == "Ingresado_Baja" then
       @resultado = "Baja ingresada por " + User.find(self.user_id).email
     
     elsif @estado == "Chequeado_Baja" then
       @resultado = "Baja chequeada por " + User.find(self.user_id).email

     elsif @estado == "Cobrado" then
       @resultado = "Cobrado"
     end
     return @resultado
   end

   def color_estado
     @estado = Estado.where(:id => self.estado_id).first.descripcion.to_s
     if (@estado == "Cancelado") || (@estado == "Cancelado_Baja") then
       @resultado = "danger"
     elsif (@estado == "Chequeado") || (@estado == "Notificado") || (@estado == "Notificado_Baja") || (@estado == "Chequeado_Baja") then
       @resultado = "success"
     elsif (@estado == "Ingresado") || (@estado == "Ingresado_Baja") then
       @resultado = "warning"
     elsif (@estado == "Impreso") || (@estado == "Cobrado")
       @resultado = "primary"
       if (AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id != nil) || (AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id != nil) then
          if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id).count > 0) then 
            if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "warning" 
            end
          elsif (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id).count > 0) then
            if (LoteImpresion.where(:id => AltasBajasHora.where(:id => self.alta_baja_hora_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "warning"
            end
          end
        end     
     end
     return @resultado   
   end

end