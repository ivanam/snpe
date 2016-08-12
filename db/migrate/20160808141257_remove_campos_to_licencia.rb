class RemoveCamposToLicencia < ActiveRecord::Migration
  def change
    remove_reference :licencia, :altas_bajas_cargo, index: true
  end
end
