class AgregarApellidosYNombresAUser < ActiveRecord::Migration
  def up
  	add_column :users, :apellidos, :string
  	add_column :users, :nombres, :string
  end

  def down
  	remove_column :users, :apellidos
  	remove_column :users, :nombres
  end
end
