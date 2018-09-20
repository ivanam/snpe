class AgregarCampoUserIdAPersona < ActiveRecord::Migration
  def change
    add_column :personas, :user_id, :integer
  end
end
