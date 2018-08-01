class AgregarNroOficina < ActiveRecord::Migration
  def change
  	add_column :licencia, :oficina, :integer
  end
end
