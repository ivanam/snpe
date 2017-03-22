class AgregarTipoArticuloAArticulo < ActiveRecord::Migration
  def change
  	add_column :articulos, :con_goce, :boolean
  	add_column :articulos, :tipo_articulo_id, :integer
  end
end
