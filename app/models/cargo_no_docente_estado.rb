class CargoNoDocenteEstado < ActiveRecord::Base
  belongs_to :cargo_no_docente
  belongs_to :estado

  def color_estado
   @estado = Estado.where(:id => self.estado_id).first.descripcion.to_s
   if (@estado == "Cancelado") || (@estado == "Cancelado_Baja") then
     @resultado = "danger"
   elsif (@estado == "Chequeado") || (@estado == "Notificado") || (@estado == "Notificado_Baja") || (@estado == "Chequeado_Baja") then
     @resultado = "success"
   elsif (@estado == "Ingresado") || (@estado == "Ingresado_Baja") then
     @resultado = "warning"
   elsif (@estado == "Impreso") then
     @resultado = "primary"
     if (CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id != nil) || (CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id != nil) then
        if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id).count > 0) then 
          if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id).first.fecha_impresion == nil) then
            @resultado = "warning" 
          end
        elsif (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id).count > 0) then
          if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
            @resultado = "warning"
          end
        end
      end     
   end
   return @resultado   
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
        if (CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id != nil) || (CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id != nil) then
          if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id).count > 0) then 
            if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.alta_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión" 
            end
          elsif (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id).count > 0) then
            if (LoteImpresion.where(:id => CargoNoDocente.where(:id => self.cargo_no_docente_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión"
            end
          end
        end     

     elsif @estado == "Notificado_Baja" then
       @resultado = "Baja notificada por " + User.find(self.user_id).email
     
     elsif @estado == "Cancelado_Baja" then
       @resultado = "Baja cancelada por " + User.find(self.user_id).email
     
     elsif @estado == "Ingresado_Baja" then
       @resultado = "Baja ingresada por " + User.find(self.user_id).email
     
     elsif @estado == "Chequeado_Baja" then
       @resultado = "Baja chequeada por " + User.find(self.user_id).email
     end
     return @resultado   
   end
end
