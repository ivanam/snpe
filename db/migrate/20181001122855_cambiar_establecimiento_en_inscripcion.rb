class CambiarEstablecimientoEnInscripcion < ActiveRecord::Migration
  def change
  	rename_column :inscripcions, :escuela_titular, :establecimiento_id
  	rename_column :inscripcions, :serv_activo, :ambito_id
  end
end
