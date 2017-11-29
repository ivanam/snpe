class CargoEstado < ActiveRecord::Base
  belongs_to :cargo
  belongs_to :estado
  belongs_to :user

  validate :control_baja


  def control_baja
    if !(self.estado_id == 7 and self.cargo.fecha_baja.to_date > '0000-00-00'.to_date)
      errors.add(:estado, "no corresponde")
    end
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
     if (Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id != nil) || (Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id != nil) then
        if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id).count > 0) then 
          if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id).first.fecha_impresion == nil) then
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
       @resultado = "Cancelado por " + User.find(self.user_id).email
     
     elsif @estado == "Chequeado" then
       @resultado = "Chequeado por " + User.find(self.user_id).email
     
     elsif @estado == "Ingresado" then
       @resultado = "Ingresado por " + User.find(self.user_id).email
    
     elsif @estado == "Notificado" then
       @resultado = "Notificado por " + User.find(self.user_id).email
    
     elsif @estado == "Impreso" then
        @resultado = "Impreso"
        if (Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id != nil) || (Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id != nil) then
          if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id).count > 0) then 
            if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión" 
            end
          elsif (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).count > 0) then
            if (LoteImpresion.where(:id => Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id).first.fecha_impresion == nil) then
              @resultado = "En cola de impresión"
            end
          end
        end
        if Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id != nil
          @resultado = @resultado + " en codigo N° " + Cargo.where(:id => self.cargo_id).first.alta_lote_impresion_id.to_s
        elsif Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id != nil
          @resultado = @resultado + " en codigo N° " + Cargo.where(:id => self.cargo_id).first.baja_lote_impresion_id.to_s
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

end
