class AgregarCampoDocumentoAUsergf < ActiveRecord::Migration
  def change
      add_column :users, :documento, :integer
  end
end
