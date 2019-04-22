class AgregarCamposALicencias < ActiveRecord::Migration
  def change
    add_column :licencia, :obs_sin_goce_cancelacion, :text
  end
end
