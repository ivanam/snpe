class CreatePeriodoLiqHoras < ActiveRecord::Migration
  def change
    create_table :periodo_liq_horas do |t|
      t.integer :mes
      t.integer :anio
      t.references :altas_bajas_hora, index: true

      t.timestamps
    end
  end
end
