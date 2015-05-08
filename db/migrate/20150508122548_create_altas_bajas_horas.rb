class CreateAltasBajasHoras < ActiveRecord::Migration
  def change
    create_table :altas_bajas_horas do |t|
      t.references :establecimiento, index: true
      t.integer :mes_periodo
      t.integer :anio_periodo
      t.references :persona, index: true
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
      t.string :oblig
      t.string :observaciones

      t.timestamps
    end
  end
end
