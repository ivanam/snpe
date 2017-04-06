class AgregarCamposAAltasBajasHoras < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :disposicion_resolucion, :string
  end
end
