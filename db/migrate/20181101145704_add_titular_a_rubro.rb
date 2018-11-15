class AddTitularARubro < ActiveRecord::Migration
  def change
	add_column :rubros, :titular, :boolean

  end
end
