class CambiarCampoTipoHora2 < ActiveRecord::Migration
   def change 
  	add_column :altas_bajas_horas, :tipo_hora_id, :integer
  	remove_column :altas_bajas_horas, :tipo_hora, :string
  end
end

