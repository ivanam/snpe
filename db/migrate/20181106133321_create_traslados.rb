class CreateTraslados < ActiveRecord::Migration
  def change
    create_table :traslados do |t|
      t.integer :alta_baja_hora_id
      t.integer :cargo_id
      t.integer :cargo_no_docente_id
      t.date :fecha_cambio_oficina
      t.integer :user_id

      t.timestamps
    end
  end
end
