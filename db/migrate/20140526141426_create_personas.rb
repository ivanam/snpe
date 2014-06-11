class CreatePersonas < ActiveRecord::Migration
  def change
    create_table :personas do |t|
      t.string :nombres
      t.string :apellidos
      t.integer :tipo_documento_id
      t.integer :nro_documento
      t.string :calle
      t.integer :nro_calle
      t.string :piso
      t.string :depto
      t.integer :estado_civil_id
      t.integer :sexo_id
      t.date :fecha_nacimiento
      t.integer :localidad_id
      t.integer :situacion_revista_id
      t.string :telefono_contacto
      t.string :email

      t.timestamps
    end
  end
end
