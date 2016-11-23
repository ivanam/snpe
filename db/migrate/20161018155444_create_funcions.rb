class CreateFuncions < ActiveRecord::Migration
  def change
    create_table :funcions do |t|
      t.string :categoria
      t.string :tipo_cargo
      t.string :descripcion
      t.integer :grupo

      t.timestamps
    end
  end
end
