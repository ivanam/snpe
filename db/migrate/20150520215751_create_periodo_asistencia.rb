class CreatePeriodoAsistencia < ActiveRecord::Migration
  def change
    create_table :periodo_asistencia do |t|
      t.string :mes
      t.integer :anio
      t.references :asistencia, index: true

      t.timestamps
    end
  end
end
