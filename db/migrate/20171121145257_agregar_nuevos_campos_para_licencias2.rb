class AgregarNuevosCamposParaLicencias2 < ActiveRecord::Migration
  def change
  	add_column :licencia, :fecha_cheq_cargada, :datetime
    add_column :licencia, :fecha_cheq_finalizada, :datetime
    add_column :licencia, :user_cheq_cargada_id, :integer
    add_column :licencia, :user_cheq_finalizada_id, :integer
  end
end
