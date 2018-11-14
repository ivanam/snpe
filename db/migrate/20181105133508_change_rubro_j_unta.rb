class ChangeRubroJUnta < ActiveRecord::Migration
  def change
	add_column :rubros, :juntafuncion_id, :integer
  end
end
