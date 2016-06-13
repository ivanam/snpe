class AgregarCamposCargo < ActiveRecord::Migration
  def change
  	add_column :cargos, :empresa_id, :integer
  	add_column :cargos, :lugar_pago_id, :integer
  	add_column :cargos, :con_movilidad, :boolean
  	add_column :cargos, :grupo_id, :integer
  	add_column :cargos,	:ina_injustificadas, :integer
  	add_column :cargos, :licencia_desde, :date
  	add_column :cargos, :licencia_hasta, :date
  	add_column :cargos, :cantidad_dias_licencia, :integer
  	add_column :cargos, :motivo_baja, :text
  end
end
