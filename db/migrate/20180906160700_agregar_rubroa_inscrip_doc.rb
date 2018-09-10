class AgregarRubroaInscripDoc < ActiveRecord::Migration
  def change
  	add_column :inscripcions, :region_id, :integer
  end
end
