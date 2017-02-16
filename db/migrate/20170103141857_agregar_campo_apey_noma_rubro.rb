class AgregarCampoApeyNomaRubro < ActiveRecord::Migration
  def change
  	add_column :rubros, :nombre_apellido, :string
  end
end
