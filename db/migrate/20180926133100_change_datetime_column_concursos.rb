class ChangeDatetimeColumnConcursos < ActiveRecord::Migration
  def change
  	change_column :concursos, :fecha_concurso, :datetime
	change_column :concursos, :fecha_inicio, :datetime
  	change_column :concursos, :fecha_fin, :datetime
  end
end
