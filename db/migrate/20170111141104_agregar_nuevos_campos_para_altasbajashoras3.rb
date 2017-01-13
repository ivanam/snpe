class AgregarNuevosCamposParaAltasbajashoras3 < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :lic_art, :string
  	add_column :altas_bajas_horas, :fecha_alta_licencia, :date
  	add_column :altas_bajas_horas, :categ, :integer
  	add_column :altas_bajas_horas, :secuencia_aux, :integer
  end
end
