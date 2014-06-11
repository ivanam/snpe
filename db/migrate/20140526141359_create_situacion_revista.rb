class CreateSituacionRevista < ActiveRecord::Migration
  def change
    create_table :situacion_revista do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
