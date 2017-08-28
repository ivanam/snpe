class AgregarCampoAnioaLicencia < ActiveRecord::Migration
  def change
  	add_column :licencia, :anio_lic, :integer
  end
end
