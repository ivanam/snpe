class AgregarCamposSituacionRevista < ActiveRecord::Migration
  def change
  	remove_column :situacion_revista, :nombre
  	add_column :situacion_revista, :codigo, :string
  	add_column :situacion_revista, :descripcion, :string
  	add_column :situacion_revista, :planta_pre, :integer
  	add_column :situacion_revista, :tipo_emp, :integer
  end
end
