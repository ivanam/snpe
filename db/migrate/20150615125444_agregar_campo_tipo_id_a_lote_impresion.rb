class AgregarCampoTipoIdALoteImpresion < ActiveRecord::Migration
  def change
    add_column :lote_impresions, :tipo_id, :integer
  end
end
