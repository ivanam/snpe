class AgregarNuevosCamposAPersona < ActiveRecord::Migration
  def change
  	add_column :personas, :apeynom, :string
 end
end
