class AgregarCodNomenCargoaRubros < ActiveRecord::Migration
  def change
  	add_column :rubros, :funcion_id, :integer
  end
end
