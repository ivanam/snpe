class AgregarCampoaRubro < ActiveRecord::Migration
  def change
  	add_column :rubros, :orden, :integer
  	add_column :rubros, :cargo, :string
  	add_column :rubros, :region, :integer
  	add_column :rubros, :cabecera, :integer
  	add_column :rubros, :apellido, :string
  	add_column :rubros, :nombre, :string
  end
end
