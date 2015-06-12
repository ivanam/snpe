class CreateCargos < ActiveRecord::Migration
  def change
    create_table :cargos do |t|
      t.references :establecimiento, index: true
      t.references :persona, index: true
      t.string :cargo
      t.integer :secuencia
      t.string :situacion_revista
      t.string :turno
      t.integer :anio
      t.integer :curso
      t.date :fecha_alta
      t.date :fecha_baja
      t.references :persona_reemplazada, index: true
      t.string :observatorio
      t.integer :alta_lote_impresion_id
      t.integer :baja_lote_impresion

      t.timestamps
    end
  end
end
