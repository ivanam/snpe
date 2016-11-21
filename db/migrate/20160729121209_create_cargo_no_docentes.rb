class CreateCargoNoDocentes < ActiveRecord::Migration
  def change
    create_table :cargo_no_docentes do |t|
      t.references :establecimiento, index: true
      t.references :persona, index: true
      t.string :cargo
      t.integer :secuencia
      t.string :turno
      t.date :fecha_alta
      t.date :fecha_baja
      t.references :persona_reemplazada, index: true
      t.string :observaciones
      t.references :alta_lote_impresion, index: true
      t.references :baja_lote_impresion, index: true
      t.integer :empresa_id
      t.integer :lugar_pago_id
      t.boolean :con_movilidad
      t.integer :ina_injustificadas
      t.date :licencia_desde
      t.date :licencia_hasta
      t.integer :cantidad_dias_licencia
      t.text :motivo_baja

      t.timestamps
    end
  end
end
