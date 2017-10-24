class AgregarDecretoALicencias < ActiveRecord::Migration
  def change
    add_column :licencia, :decreto, :string
    add_column :licencia, :resolucion, :string
    add_column :licencia, :destino, :integer
  end
end
