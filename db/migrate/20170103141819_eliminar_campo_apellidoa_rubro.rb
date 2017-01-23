class EliminarCampoApellidoaRubro < ActiveRecord::Migration
  def change
  	remove_column :rubros, :apellido
  end
end
