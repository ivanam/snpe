class CreateOficinas < ActiveRecord::Migration
  def change
    create_table :oficinas do |t|
      t.integer :nombre
      t.integer :tipo

      t.timestamps
    end
  end
end
