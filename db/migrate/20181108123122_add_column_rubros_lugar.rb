class AddColumnRubrosLugar < ActiveRecord::Migration
  def change
	add_column :rubros, :otro_lugar, :string
  end
end
