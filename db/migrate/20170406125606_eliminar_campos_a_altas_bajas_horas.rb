class EliminarCamposAAltasBajasHoras < ActiveRecord::Migration
  def change
  	remove_column :altas_bajas_horas, :disposicion_resolucion
  	add_column :altas_bajas_horas, :resolucion, :string
  	add_column :altas_bajas_horas, :decreto, :string
  end
end
