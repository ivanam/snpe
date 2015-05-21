class CreateLoteImpresions < ActiveRecord::Migration
  def change
    create_table :lote_impresions do |t|
      t.date :fecha_impresion
      t.text :observaciones

      t.timestamps
    end
  end
end
