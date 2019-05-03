class AgregoCamposParaDesglose < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :secuencia_original, :integer
  	add_column :altas_bajas_horas, :desglose_horas_id, :integer
  end
end
