class CambiarCamposCargo < ActiveRecord::Migration
  def change
  	remove_column :cargos, :motivo_baja, :text
  	add_column :cargos, :motivo_baja, :string
  end
end
