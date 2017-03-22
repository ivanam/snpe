class AgregarCampoEstadoACargos < ActiveRecord::Migration
  def change
	add_column :cargos, :estado, :string
  end
end
