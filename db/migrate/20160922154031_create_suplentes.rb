class CreateSuplentes < ActiveRecord::Migration
  def change
    create_table :suplentes do |t|
      t.references :altas_bajas_hora, index: true
      t.references :altas_bajas_hora_suplantada, index: true
      t.date :fecha_desde
      t.date :fecha_hasta
      t.text :observaciones
      t.string :estado

      t.timestamps
    end
  end
end
