class AgregarCamporALicenciasSinGoce < ActiveRecord::Migration
  def change
    add_column :licencia, :cancelada_sin_goce, :boolean
    add_column :licencia, :obs_sin_goce_cancelacion, :text

  end
end
