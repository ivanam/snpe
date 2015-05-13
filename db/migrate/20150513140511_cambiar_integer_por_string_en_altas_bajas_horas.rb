class CambiarIntegerPorStringEnAltasBajasHoras < ActiveRecord::Migration
  def up
  	change_column :personas, :cuil, :string
  end

  def down
  	change_column :personas, :cuil, :string
  end
end
