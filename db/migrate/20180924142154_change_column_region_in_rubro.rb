class ChangeColumnRegionInRubro < ActiveRecord::Migration
  def change
  	change_column :rubros, :region, :integer
  	rename_column :rubros, :region, :region_id
  end
end
