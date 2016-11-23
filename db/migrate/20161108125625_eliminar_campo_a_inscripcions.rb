class EliminarCampoAInscripcions < ActiveRecord::Migration
  def change
  	remove_column :inscripcions, :pesona_id
  end
end
