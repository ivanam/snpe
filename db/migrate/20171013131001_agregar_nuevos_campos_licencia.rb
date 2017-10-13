class AgregarNuevosCamposLicencia < ActiveRecord::Migration
  def change
    add_column :licencia, :por_continua, :boolean
  end
end

