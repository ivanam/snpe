class CreateTitulos < ActiveRecord::Migration
  def change
    create_table :titulos do |t|
      t.string :nombre
      t.integer :persona_id
      t.references :persona, index: true

      t.timestamps
    end
  end
end
