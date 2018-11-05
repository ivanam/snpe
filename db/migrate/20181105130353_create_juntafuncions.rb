class CreateJuntafuncions < ActiveRecord::Migration
  def change
    create_table :juntafuncions do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
