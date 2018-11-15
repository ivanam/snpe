class ChangeCargoInscripDocsJUnta < ActiveRecord::Migration
  def change
  	add_column :cargo_inscrip_docs, :juntafuncion_id, :integer
  end
end
