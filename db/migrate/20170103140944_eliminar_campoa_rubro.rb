class EliminarCampoaRubro < ActiveRecord::Migration
  def change
  	remove_column :rubros, :pesona_id
  end
end
