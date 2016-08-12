class AddCamposToCargoNoDocenteEstados < ActiveRecord::Migration
  def change
    add_reference :cargo_no_docente_estados, :user, index: true
    add_column :cargo_no_docente_estados, :observaciones, :text
  end
end
