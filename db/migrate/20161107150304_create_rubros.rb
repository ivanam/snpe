class CreateRubros < ActiveRecord::Migration
  def change
    create_table :rubros do |t|
      t.integer :pesona_id
      t.integer :escuela_id
      t.string :rubro_titulo
      t.string :rubro_concepto
      t.string :rubro_asis_perf
      t.string :rubro_ser_prest
      t.string :rubro_residencia
      t.string :rubro_gestion
      t.string :rubro_cursos
      t.string :ant_doc
      t.string :rubro_titulo
      t.integer :total
      t.integer :promedio
      t.references :persona, index: true
      t.references :establecimiento, index: true

      t.timestamps
    end
  end
end
