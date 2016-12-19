class AgregarNuevosCamposACargos < ActiveRecord::Migration
  def change
  	add_column :cargos, :materium_id, :string
  end
end
