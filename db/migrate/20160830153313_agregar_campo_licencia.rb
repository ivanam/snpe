class AgregarCampoLicencia < ActiveRecord::Migration
  def change
  	add_column :licencia, :vigente, :string
  end
end
