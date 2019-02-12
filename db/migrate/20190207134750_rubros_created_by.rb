class RubrosCreatedBy < ActiveRecord::Migration
  def change
	add_column :rubros, :updated_by, :integer
	add_column :rubros, :created_by, :integer  
  end
end
