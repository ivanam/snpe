class CreatePeriodoLiqCargos < ActiveRecord::Migration
  def change
    create_table :periodo_liq_cargos do |t|
      t.string :mes
      t.integer :anio
      t.references :altas_bajas_cargo, index: true

      t.timestamps
    end
  end
end
