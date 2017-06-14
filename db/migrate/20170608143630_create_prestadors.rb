class CreatePrestadors < ActiveRecord::Migration
  def change
    create_table :prestadors do |t|
      t.string :nombre
      t.string :matricula
      t.integer :especialidad_id
      t.references :especialidad, index: true

      t.timestamps
    end
  end
end
