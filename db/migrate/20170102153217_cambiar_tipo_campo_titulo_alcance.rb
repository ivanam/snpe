class CambiarTipoCampoTituloAlcance < ActiveRecord::Migration
   def up
  	change_column :titulos, :alcance, :integer
  end

  def down
  	change_column :titulos, :alcance, :integer
  end
end
