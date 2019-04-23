class AgregoCampoALicenciaQueCanceloLaLicencia < ActiveRecord::Migration
  def change
    add_column :licencia, :user_sin_goce_cancelada, :integer 
  end
end
