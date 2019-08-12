class AgregoCampoATablaHoras < ActiveRecord::Migration
  def change
      add_column :altas_bajas_horas, :migracion_fecha, :date
  end
end
