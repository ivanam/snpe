class RemoveCampoToSuplente < ActiveRecord::Migration
  def change
  	remove_reference :suplentes, :altas_bajas_hora_suplantada, index: true
  end
end
