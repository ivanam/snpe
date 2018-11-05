class AddColumnLugartitularidadRubro < ActiveRecord::Migration
  def change
  	add_column :rubros, :establecimiento_id, :integer
  	add_column :rubros, :ambito_id, :integer
  end
end
