class AgregarEstadoACargosDyCargosNd < ActiveRecord::Migration
  def change
  	add_column :cargo_no_docentes, :estado, :string
  	add_column :cargo_no_docentes, :situacion_revista, :string
  end
end
