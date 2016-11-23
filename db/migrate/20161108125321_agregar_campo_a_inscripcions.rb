class AgregarCampoAInscripcions < ActiveRecord::Migration
  def change
  	add_column :inscripcions, :persona_id, :integer
  end
end
