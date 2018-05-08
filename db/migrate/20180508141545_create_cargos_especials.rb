class CreateCargosEspecials < ActiveRecord::Migration
  def change
    create_table :cargos_especials do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
