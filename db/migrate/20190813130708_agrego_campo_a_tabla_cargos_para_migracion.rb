class AgregoCampoATablaCargosParaMigracion < ActiveRecord::Migration
  def change
        add_column :cargos, :migracion_fecha, :date
        add_column :cargos, :estado_migrado, :string
  end
end
