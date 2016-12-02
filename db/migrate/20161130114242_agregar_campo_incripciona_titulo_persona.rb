class AgregarCampoIncripcionaTituloPersona < ActiveRecord::Migration
  def change
  	add_column :titulo_personas, :inscripcion_id, :integer
  end
end
