class AgregarPorBajaALicencia < ActiveRecord::Migration
  def change
    add_column :licencia, :por_baja, :boolean
  end
end
