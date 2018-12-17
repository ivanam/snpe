class AgregarCamposARegistrosParaCorregir < ActiveRecord::Migration
  def change
    add_column :registros_para_solucionars, :mes_liq, :integer
    add_column :registros_para_solucionars, :anio_liq, :integer

  end
end
