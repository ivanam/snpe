class CreateEstablecimientos < ActiveRecord::Migration
  def change
    create_table :establecimientos do |t|
      t.string :codigo_jurisdiccional
      t.integer :cue
      t.integer :anexo
      t.integer :cue_anexo
      t.string :sector
      t.string :ambito
      t.string :nombre
      t.integer :localidad_id
      t.string :domicilio

      t.timestamps
    end
  end
end
