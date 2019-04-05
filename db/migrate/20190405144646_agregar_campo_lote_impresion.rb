class AgregarCampoLoteImpresion < ActiveRecord::Migration
  def change
      add_column :lote_impresions, :establecimiento_id, :integer 
  end
end
