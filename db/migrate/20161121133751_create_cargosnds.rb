class CreateCargosnds < ActiveRecord::Migration
  def change
    create_table :cargosnds do |t|
      t.integer :cargo_agrup
      t.integer :cargo_cod
      t.integer :cargo_categ
      t.integer :nivel
      t.string :cargo_desc

      t.timestamps
    end
  end
end
