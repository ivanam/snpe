class AgregarCampoCabeceraInscripcion < ActiveRecord::Migration
  def change
  	add_column :inscripcions, :cabecera, :integer
  end
end
