class AgregarCampoAlicencia < ActiveRecord::Migration
  def change
  	add_column :licencia, :prestador_id, :integer
  end
end
