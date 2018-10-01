class RemoveInscripcionAAmbito < ActiveRecord::Migration
  def change
  	remove_column :ambitos, :inscripcion_id
  end
end
