class AgregaCampoaUserIdIncripcion < ActiveRecord::Migration
  def change
  	add_column :inscripcions, :user_id, :integer
  end
end
