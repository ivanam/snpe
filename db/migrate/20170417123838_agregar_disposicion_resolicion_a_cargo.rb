class AgregarDisposicionResolicionACargo < ActiveRecord::Migration
  def change

    add_column :cargos, :disposicion, :string
    add_column :cargos, :resolucion, :string

  end
end
