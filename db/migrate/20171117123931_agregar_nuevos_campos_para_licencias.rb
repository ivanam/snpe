class AgregarNuevosCamposParaLicencias < ActiveRecord::Migration
   def change
    add_column :licencia, :cargada, :boolean
    add_column :licencia, :finalizada, :boolean
  end
end
