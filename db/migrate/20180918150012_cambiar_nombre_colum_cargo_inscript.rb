class CambiarNombreColumCargoInscript < ActiveRecord::Migration
  def change
  	    rename_column :cargo_inscrip_docs, :cargo_id, :funcion_id

  end
end
