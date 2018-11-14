class AddUpdatedByInscripcion < ActiveRecord::Migration
  def change
	add_column :inscripcions, :updated_by, :integer
	add_column :inscripcions, :created_by, :integer
  end
end
