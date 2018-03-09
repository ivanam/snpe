class CreateHistorialCargos < ActiveRecord::Migration
  def change
    create_table :historial_cargos do |t|
      t.integer :establecimiento_id
      t.integer :persona_id
      t.string :cargo
      t.integer :secuencia
      t.string :situacion_revista
      t.string :turno
      t.integer :anio
      t.integer :curso
      t.date :fecha_alta
      t.date :fecha_baja
      t.integer :persona_reemplazada_id
      t.string :observatorio
      t.integer :alta_lote_impresion_id
      t.datetime :created_at
      t.datetime :updated_at
      t.integer :division
      t.text :observaciones
      t.integer :baja_lote_impresion_id
      t.integer :empresa_id
      t.integer :lugar_pago_id
      t.boolean :con_movilidad
      t.integer :grupo_id
      t.integer :ina_injustificadas
      t.date :licencia_desde
      t.date :licencia_hasta
      t.integer :cantidad_dias_licencia
      t.string :motivo_baja
      t.string :estado
      t.string :materium_id
      t.string :disposicion
      t.string :resolucion

      t.timestamps
    end
  end
end
