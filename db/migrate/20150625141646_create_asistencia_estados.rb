class CreateAsistenciaEstados < ActiveRecord::Migration
  def change
    create_table :asistencia_estados do |t|
      t.references :asistencia, index: true
      t.references :estado, index: true
      t.references :user, index: true
      t.text :observaciones

      t.timestamps
    end
  end
end
