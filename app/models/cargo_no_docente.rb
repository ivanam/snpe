class CargoNoDocente < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :alta_lote_impresion_id
  belongs_to :baja_lote_impresion






  def estado_actual
    @relation = CargoEstado.where(:cargo_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end
end
