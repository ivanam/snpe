class AgregarSuplenteAHora < ActiveRecord::Migration
  def change
  	add_reference :altas_bajas_horas, :suplente, index: true
  end
end
