class AgregarObservacionesYUsuarioEnHoraEstado < ActiveRecord::Migration
  def change
    add_column :altas_bajas_hora_estados, :user_id, :integer
  end
end
