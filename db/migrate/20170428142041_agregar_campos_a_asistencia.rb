class AgregarCamposAAsistencia < ActiveRecord::Migration
  def change

    add_column :asistencia, :altas_bajas_cargo_no_docente_id, :integer

  end
end
