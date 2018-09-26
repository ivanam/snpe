class CreateConcursos < ActiveRecord::Migration
  def change
    create_table :concursos do |t|
      t.date :fecha_concurso
      t.date :fecha_inicio
      t.date :fecha_fin
      t.string :descripcion

      t.timestamps
    end
  end
end
