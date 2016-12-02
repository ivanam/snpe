class CreateAmbitos < ActiveRecord::Migration
  def change
    create_table :ambitos do |t|
      t.string :nombre
      t.references :inscripcion, index: true

      t.timestamps
    end
  end
end
