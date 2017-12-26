class AgregarLugarPagoAEstablecimientos < ActiveRecord::Migration
  def change
    add_column :establecimientos, :lugar_pago, :integer
  end
end
