class EliminarCapoTipoHora < ActiveRecord::Migration
  def change
  	remove_column :altas_bajas_horas, :TipoHora
  end
end
