class CreateLicencia < ActiveRecord::Migration
  def change
    create_table :licencia do |t|
      t.references :altas_bajas_hora, index: true
      t.references :altas_bajas_cargo, index: true
      t.date :fecha_desde
      t.date :fecha_hasta
      t.references :articulo, index: true

      t.timestamps
    end
  end
end
