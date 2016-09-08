class AgregarCampoPlanId < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :plan_id, :integer
  end  
end
