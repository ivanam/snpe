class AgregarCampoLoteBajaAHoras < ActiveRecord::Migration
  def change
    add_column :altas_bajas_horas, :baja_lote_impresion_id, :integer
  end
end
