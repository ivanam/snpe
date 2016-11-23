class AgregarCamposAHoras < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :empresa_id, :integer
  	add_column :altas_bajas_horas, :lugar_pago_id, :integer
  	add_column :altas_bajas_horas, :estado, :string  	
  	add_column :altas_bajas_horas, :con_movilidad, :boolean
  	add_column :altas_bajas_horas, :materium_id, :integer
  	add_column :altas_bajas_horas, :grupo_id, :integer
  	add_column :altas_bajas_horas, :motivo_baja, :string
  end
end
