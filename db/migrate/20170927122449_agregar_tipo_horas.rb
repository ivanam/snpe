class AgregarTipoHoras < ActiveRecord::Migration
   def change
  	add_column :altas_bajas_horas, :tipo_hora, :string 
  end
end
