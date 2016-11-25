class CreateCargoInscripDocs < ActiveRecord::Migration
  def change
    create_table :cargo_inscrip_docs do |t|
      t.integer :incripcion_id
      t.integer :persona_id
      t.integer :cargosnds_id
      t.integer :cargo_id
      t.integer :nivel_id
      t.references :inscripcion, index: true
      t.references :cargo, index: true
      t.references :nivel, index: true
      t.references :persona, index: true
      t.references :cargosnds, index: true

      t.timestamps
    end
  end
end
