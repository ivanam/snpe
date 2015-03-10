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
      t.string :responsable
      t.string :tipo
      t.string :zona
      t.integer :cuise
      t.date :alta
      t.date :baja
      t.string :dependencia
      t.string :email
      t.string :isotipo
      t.string :nivel_id
      t.string :ift
      t.integer :numero
      t.boolean :privada
      t.string :rght
      t.string :sistema
      t.integer :organizacion_id

      t.timestamps
    end
  end
end
