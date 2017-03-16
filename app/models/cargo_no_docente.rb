class CargoNoDocente < ActiveRecord::Base
  belongs_to :establecimiento
  belongs_to :persona
  belongs_to :persona_reemplazada
  belongs_to :alta_lote_impresion
  belongs_to :baja_lote_impresion
  has_many :estados, :class_name => 'CargoNoDocenteEstado', :foreign_key => 'cargo_no_docente_id', dependent: :destroy


  def estado_actual
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end

  def estado_anterior
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).last
    @relation = CargoNoDocenteEstado.where(:cargo_no_docente_id => self.id).where.not(id: @relation.id).last
    if @relation == nil
      return "Vacio"
    else
      return @relation.estado.descripcion
    end
  end 
end
