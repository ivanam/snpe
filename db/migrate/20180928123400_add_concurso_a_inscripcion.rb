class AddConcursoAInscripcion < ActiveRecord::Migration
  def change
      add_column :inscripcions, :concurso_id, :integer
  end
end
