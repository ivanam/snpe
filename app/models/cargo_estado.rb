class CargoEstado < ActiveRecord::Base
  belongs_to :cargo
  belongs_to :estado
  belongs_to :user


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
     if (Cargo.where(:id => self.cargo_id).first.lote_impresion_id != nil) || (Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id != nil) then
        if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.lote_impresion_id).count > 0) then 
          if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.lote_impresion_id).first.fecha_impresion == nil) then
            @resultado = "warning" 
          end
        elsif (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).count > 0) then
          if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
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
       @resultado = "Cancelado por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     
     elsif @estado == "Chequeado" then
       @resultado = "Chequeado por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     
     elsif @estado == "Ingresado" then
       @resultado = "Ingresado por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
    
     elsif @estado == "Notificado" then
       @resultado = "Notificado por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
    
     elsif @estado == "Impreso" then
        @resultado = "Impreso"
        if (Cargo.where(:id => self.cargo_id).first.lote_impresion_id != nil) || (Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id != nil) then
          if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.lote_impresion_id).count > 0) then 
            if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión" 
            end
          elsif (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).count > 0) then
            if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión"
            end
          end
        end     

     elsif @estado == "Notificado_Baja" then
       @resultado = "Baja notificada por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     
     elsif @estado == "Cancelado_Baja" then
       @resultado = "Baja cancelada por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     
     elsif @estado == "Ingresado_Baja" then
       @resultado = "Baja ingresada por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     
     elsif @estado == "Chequeado_Baja" then
       @resultado = "Baja chequeada por " + Role.where(:id => (UserRole.where(:user_id => self.user_id).first.role_id)).first.description.to_s
     end
     return @resultado   
   end

end
