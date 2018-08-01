class EliminaCampoOficina < ActiveRecord::Migration
  def change
  	remove_column :establecimientos, :oficina
  end
end
