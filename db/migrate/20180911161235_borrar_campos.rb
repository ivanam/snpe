class BorrarCampos < ActiveRecord::Migration
  def change
    remove_column :inscripcions, :funcion_id
    remove_column :inscripcions, :establecimiento_id
    remove_column :inscripcions, :nivel_id
    remove_column :inscripcions, :cabecera

    remove_column :rubros, :escuela_id
    remove_column :rubros, :nombre_apellido
    remove_column :rubros, :cargo
    remove_column :rubros, :establecimiento_id
    
    remove_column :cargo_inscrip_docs, :cargosnds_id
    remove_column :cargo_inscrip_docs, :nivel_id
    
  end
end
