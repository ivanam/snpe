class CambiarCampoTipoHora < ActiveRecord::Migration
  def change
  	  remove_column :altas_bajas_horas, :TipoHora, :string
      add_column :altas_bajas_horas, :tipo_hora, :string
  end
end
