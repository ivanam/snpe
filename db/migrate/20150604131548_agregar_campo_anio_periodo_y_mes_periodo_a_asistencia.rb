class AgregarCampoAnioPeriodoYMesPeriodoAAsistencia < ActiveRecord::Migration
  def change
    add_column :asistencia, :anio_periodo, :integer
    add_column :asistencia, :mes_periodo, :integer
  end
end
