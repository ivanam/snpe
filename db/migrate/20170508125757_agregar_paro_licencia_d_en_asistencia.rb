class AgregarParoLicenciaDEnAsistencia < ActiveRecord::Migration
  def change
    add_column :asistencia, :paro, :integer
    add_column :asistencia, :licencia_d, :integer
    add_column :asistencia, :observaciones, :text
  end
end
