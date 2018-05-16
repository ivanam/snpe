class AddSedeAEstablecimiento < ActiveRecord::Migration
  def change
    add_column :establecimientos, :sede, :boolean
  end
end
