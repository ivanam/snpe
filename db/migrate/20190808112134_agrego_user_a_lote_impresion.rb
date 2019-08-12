class AgregoUserALoteImpresion < ActiveRecord::Migration
  def change
      add_column :lote_impresions, :user_id, :integer 
  end
end
