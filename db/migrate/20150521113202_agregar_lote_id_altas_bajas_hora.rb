class AgregarLoteIdAltasBajasHora < ActiveRecord::Migration
   def change
    add_column :altas_bajas_horas, :lote_impresion_id, :integer
  end
end
