class AgregarAnioAHistorial < ActiveRecord::Migration
  def change
    add_column :historial_cargos, :anio, :integer

  end
end
