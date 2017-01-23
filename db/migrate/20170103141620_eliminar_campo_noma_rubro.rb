class EliminarCampoNomaRubro < ActiveRecord::Migration
  def change
  	remove_column :rubros, :nombre
  end
end
