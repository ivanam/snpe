class CambiarTipoDato < ActiveRecord::Migration
  def change
    change_column :cargos, :obs_lic, :text
    change_column :cargo_no_docentes, :obs_lic, :text
    change_column :altas_bajas_horas, :obs_lic, :text
  end
end
