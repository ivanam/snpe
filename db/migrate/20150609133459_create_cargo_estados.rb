class CreateCargoEstados < ActiveRecord::Migration
  def change
    create_table :cargo_estados do |t|
      t.references :cargo, index: true
      t.references :estado, index: true
      t.references :user, index: true
      t.text :observaciones

      t.timestamps
    end
  end
end
