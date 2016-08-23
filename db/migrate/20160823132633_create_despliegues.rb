class CreateDespliegues < ActiveRecord::Migration
  def change
    create_table :despliegues do |t|
      t.integer :anio
      t.references :plan, index: true
      t.references :materia, index: true
      t.integer :carga_horaria

      t.timestamps
    end
  end
end
