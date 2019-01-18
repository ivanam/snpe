class AgregarCamposALicencia < ActiveRecord::Migration
  def change
    add_column :licencia, :organismo, :string
  end
end
