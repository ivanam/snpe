class CambiarIntPorTextEnObservacionesCargo < ActiveRecord::Migration
  def up
  	change_column :cargos, :observaciones, :text
  end

  def down
  	change_column :cargos, :observaciones, :text
  end
end
