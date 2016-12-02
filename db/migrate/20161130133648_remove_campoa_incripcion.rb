class RemoveCampoaIncripcion < ActiveRecord::Migration
  def change
  	remove_column :cargo_inscrip_docs, :incripcion_id
  end
end
