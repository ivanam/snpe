class AgregarCampoObservacionesaRubro < ActiveRecord::Migration
  def change
  	add_column :rubros, :observaciones, :string
  end
end
