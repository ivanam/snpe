class AgregarCampoASuplente < ActiveRecord::Migration
  def change
  	add_column :suplentes, :tipo_suplente, :string
  end
end
