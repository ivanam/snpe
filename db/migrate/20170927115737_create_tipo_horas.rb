class CreateTipoHoras < ActiveRecord::Migration
  def change
    create_table :tipo_horas do |t|
      t.string :nombre
      t.timestamps
    end
  end
end
