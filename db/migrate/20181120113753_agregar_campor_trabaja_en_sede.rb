class AgregarCamporTrabajaEnSede < ActiveRecord::Migration
  def change
      add_column :cargos, :trabaja_en_sede, :boolean
      add_column :cargo_no_docentes, :trabaja_en_sede, :boolean
      add_column :altas_bajas_horas, :trabaja_en_sede, :boolean
  end
end
