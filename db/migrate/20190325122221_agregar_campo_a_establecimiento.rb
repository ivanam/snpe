class AgregarCampoAEstablecimiento < ActiveRecord::Migration
  def change
    add_column :establecimientos, :migrada, :boolean 
  end
end
