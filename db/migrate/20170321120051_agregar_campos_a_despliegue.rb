class AgregarCamposADespliegue < ActiveRecord::Migration
  def change
  	add_column :despliegues, :cant_docentes, :integer
  	add_column :despliegues, :observacion, :string
  end
end
