class CambiarIntegerPorStringCodificacion < ActiveRecord::Migration
  def up
  	change_column :altas_bajas_horas, :codificacion, :string
  end

  def down
  	change_column :altas_bajas_horas, :codificacion, :string
  end
end
