class CreatePlanillaIncompatibilidads < ActiveRecord::Migration
  def change
    create_table :planilla_incompatibilidads do |t|
      t.integer :numero
      t.string :nota_ingreso
      t.string :apellido
      t.string :nombre
      t.integer :dni
      t.date :fecha_nacimiento
      t.integer :escuela_a
      t.integer :escuela_b
      t.integer :escuela_c
      t.integer :escuela_d
      t.integer :escuela_e
      t.text :observaciones_inc
      t.date :fecha1
      t.string :observaciones_suel
      t.string :text
      t.date :fecha2

      t.timestamps
    end
  end
end
