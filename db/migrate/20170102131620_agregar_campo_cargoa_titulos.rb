class AgregarCampoCargoaTitulos < ActiveRecord::Migration
  def change
   add_column :titulos, :cargo, :string 
  end
end
