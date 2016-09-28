class AgregarCampoAArticulo < ActiveRecord::Migration
  def change
  	add_column :articulos, :suplencia, :string
  end
end
