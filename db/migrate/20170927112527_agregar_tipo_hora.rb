class AgregarTipoHora < ActiveRecord::Migration
   def change
  	add_column :altas_bajas_horas, :TipoHora, :string 
  end
end
