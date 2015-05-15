class CreateArticulos < ActiveRecord::Migration
  def change
    create_table :articulos do |t|
      t.string :codigo
      t.string :descripcion
      t.integer :cantidad_maxima_dias

      t.timestamps
    end
  end
end
