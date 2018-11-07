class AgregarCampoCheckEntregaCertificado < ActiveRecord::Migration
  def change
    add_column :licencia, :con_certificado, :boolean
  end
end
