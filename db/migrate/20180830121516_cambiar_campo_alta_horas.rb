class CambiarCampoAltaHoras < ActiveRecord::Migration
  def change
    change_column :altas_bajas_horas, :observaciones, :text
  end
end
