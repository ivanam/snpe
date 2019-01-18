class AgregarCamposAArticulo < ActiveRecord::Migration
  def change
    add_column :articulos, :permite_otro_organismo, :boolean, :default => false
  end
end
