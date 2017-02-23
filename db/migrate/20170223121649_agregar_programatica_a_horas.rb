class AgregarProgramaticaAHoras < ActiveRecord::Migration
  def change
	add_column :altas_bajas_horas, :programatica, :boolean
  end
end
