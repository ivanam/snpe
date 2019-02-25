class CreateMotivoBajas < ActiveRecord::Migration
  def change
    create_table :motivo_bajas do |t|
      t.integer :nro_motivo
      t.string :motivo

      t.timestamps
    end
  end
end
