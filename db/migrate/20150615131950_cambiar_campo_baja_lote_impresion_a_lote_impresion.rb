class CambiarCampoBajaLoteImpresionALoteImpresion < ActiveRecord::Migration
  def change
    remove_column :cargos, :baja_lote_impresion, :integer
    add_column :cargos, :baja_lote_impresion_id, :integer
  end
end
