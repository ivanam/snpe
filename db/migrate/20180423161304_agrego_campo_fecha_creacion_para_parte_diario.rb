class AgregoCampoFechaCreacionParaParteDiario < ActiveRecord::Migration
  def change
  	add_column :licencia, :fecha_creacion, :date

  end
end
