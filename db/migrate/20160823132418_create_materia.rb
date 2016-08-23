class CreateMateria < ActiveRecord::Migration
  def change
    create_table :materia do |t|
      t.integer :codigo
      t.string :descripcion

      t.timestamps
    end
  end
end
