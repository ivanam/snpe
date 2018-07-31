class AgregarNroDocLicen < ActiveRecord::Migration
  def change
  	add_column :licencia, :nro_documento, :bigint
  end
end
