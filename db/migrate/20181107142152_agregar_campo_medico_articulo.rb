class AgregarCampoMedicoArticulo < ActiveRecord::Migration
  def change
    add_column :articulos, :medico, :boolean
  end
end
