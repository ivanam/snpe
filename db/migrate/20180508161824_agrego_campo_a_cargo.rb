class AgregoCampoACargo < ActiveRecord::Migration
  def change
  	add_column :cargos, :cargo_especial_id, :integer
  end
end
