class BorrarCampoLicencia < ActiveRecord::Migration
  def change
    remove_column :licencia, :vigente
  end
end
