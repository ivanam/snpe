class LimpiarBase01 < ActiveRecord::Migration
  def up
    drop_table :suplentes
    drop_table :primaria_cargos
    drop_table :oficinas
    drop_table :periodo_liq_cargos
    drop_table :periodo_liq_horas
    drop_table :periodo_asistencia

  end

  def down
    fail ActiveRecord::IrreversibleMigration
  end
end
