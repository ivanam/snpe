class CambiarCampoRegionaRubro < ActiveRecord::Migration
  def up
  	change_column :rubros, :region, :string
  end

  def down
  	change_column :rubros, :region, :string
  end
end