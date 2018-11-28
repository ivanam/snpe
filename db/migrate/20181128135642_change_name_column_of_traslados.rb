class ChangeNameColumnOfTraslados < ActiveRecord::Migration
  def change
	rename_column :traslados, :alta_baja_hora_id, :altas_bajas_hora_id
  end
end
