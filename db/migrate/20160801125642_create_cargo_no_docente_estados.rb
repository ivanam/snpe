class CreateCargoNoDocenteEstados < ActiveRecord::Migration
  def change
    create_table :cargo_no_docente_estados do |t|
      t.references :cargo_no_docente, index: true
      t.references :estado, index: true

      t.timestamps
    end
  end
end
