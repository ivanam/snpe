class AgregarCamposACargosHorasYaUxiliaresObs < ActiveRecord::Migration
  def change
    add_column :cargos, :obs_lic, :integer
    add_column :cargo_no_docentes, :obs_lic, :integer
    add_column :altas_bajas_horas, :obs_lic, :integer
  end
end
