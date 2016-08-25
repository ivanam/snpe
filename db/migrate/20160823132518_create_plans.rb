class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
