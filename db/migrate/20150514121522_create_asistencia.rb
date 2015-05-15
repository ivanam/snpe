class CreateAsistencia < ActiveRecord::Migration
  def change
    create_table :asistencia do |t|
      t.integer :ina_justificada
      t.integer :ina_injustificada
      t.integer :ina_total
      t.integer :lleg_tarde_justificada
      t.integer :lleg_tarde_injustificada
      t.integer :lleg_tarde_total
      t.references :altas_bajas_hora, index: true
      t.references :altas_bajas_cargo, index: true

      t.timestamps
    end
  end
end
