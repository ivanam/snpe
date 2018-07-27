class AgregarCampoUserALicencia < ActiveRecord::Migration
  def change
  	    add_column :licencia, :user_id, :integer
  end
end
