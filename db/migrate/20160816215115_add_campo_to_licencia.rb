class AddCampoToLicencia < ActiveRecord::Migration
  def change
  	add_column :licencia, :vigente, :boolean
    add_column :licencia, :observaciones, :text
  end
end
