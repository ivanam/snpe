class AgregarCampoNivelACargo < ActiveRecord::Migration
  def change
  	add_column :funcions, :nivel, :string
  end
end
