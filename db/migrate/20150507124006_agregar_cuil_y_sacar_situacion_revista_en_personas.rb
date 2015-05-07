class AgregarCuilYSacarSituacionRevistaEnPersonas < ActiveRecord::Migration
  def change
    add_column :personas, :cuil, :integer
    remove_columns :personas, :situacion_revista_id
  end
end
