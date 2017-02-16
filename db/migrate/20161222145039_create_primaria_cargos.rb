class CreatePrimariaCargos < ActiveRecord::Migration
  def change
    create_table :primaria_cargos do |t|
      t.string :descripcion
      t.integer :codigo_nomen
      t.references :cargo_inscrip_doc, index: true
      t.references :inscripcion, index: true
      t.references :funcion, index: true

      t.timestamps
    end
  end
end
