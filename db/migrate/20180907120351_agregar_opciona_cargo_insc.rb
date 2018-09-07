class AgregarOpcionaCargoInsc < ActiveRecord::Migration
  def change
  	add_column :cargo_inscrip_docs, :opcion, :integer
  end
end
