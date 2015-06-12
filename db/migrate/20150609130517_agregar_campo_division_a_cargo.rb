class AgregarCampoDivisionACargo < ActiveRecord::Migration
  def change
    add_column :cargos, :division, :integer
  end
end
