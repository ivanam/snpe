class CreateRegistrosParaSolucionars < ActiveRecord::Migration
  def change
    create_table :registros_para_solucionars do |t|
      t.boolean :horas_registro
      t.boolean :cargos_registro
      t.boolean :auxiliar_registro
      t.integer :establecimiento_id
      t.integer :persona_id
      t.integer :secuencia
      t.date :fecha_alta
      t.date :fecha_baja
      t.string :situacion_revista
      t.integer :horas
      t.integer :ciclo_carrera
      t.integer :anio
      t.integer :division
      t.string :turno
      t.integer :codificacion
      t.string :estado
      t.integer :materium_id
      t.integer :plan_id
      t.integer :cargo

      t.timestamps
    end
  end
end
