class AgregarAtribProvi < ActiveRecord::Migration
  def change
  	add_column :altas_bajas_horas, :esprovisorio, :boolean
  	add_column :cargos, :esprovisorio, :boolean
  end
end
