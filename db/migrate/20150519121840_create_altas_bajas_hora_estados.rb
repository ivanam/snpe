class CreateAltasBajasHoraEstados < ActiveRecord::Migration
  def change
    create_table :altas_bajas_hora_estados do |t|
      t.references :alta_baja_hora, index: true
      t.references :estado, index: true
      t.text :observaciones

      t.timestamps
    end
  end
end
