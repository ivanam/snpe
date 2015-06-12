class AgregarCampoObservacionesACargo < ActiveRecord::Migration
  def change
    add_column :cargos, :observaciones, :integer
  end
end
