class CreateTipoArticulos < ActiveRecord::Migration
  def change
    create_table :tipo_articulos do |t|
      t.string :descripcion

      t.timestamps
    end
  end
end
