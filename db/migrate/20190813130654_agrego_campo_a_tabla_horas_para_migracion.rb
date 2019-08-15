class AgregoCampoATablaHorasParaMigracion < ActiveRecord::Migration
  def change
    add_column :altas_bajas_horas, :estado_migrado, :string
  end
end
