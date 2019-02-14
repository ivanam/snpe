class AgregarCamposARegistorsParaCorregir < ActiveRecord::Migration
  def change
    add_column :registros_para_solucionars, :chequeada, :boolean
    add_column :registros_para_solucionars, :user_chequeada_id, :integer
    add_column :registros_para_solucionars, :fecha_chequeada, :date

  end
end
