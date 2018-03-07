class AgregarAnioAHistorial < ActiveRecord::Migration
  def change
    add_column :historial_cargos, :anio_pof, :integer

  end
end
