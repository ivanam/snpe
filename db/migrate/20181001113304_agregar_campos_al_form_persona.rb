class AgregarCamposAlFormPersona < ActiveRecord::Migration
  def change
    add_column :personas, :anio, :integer
    add_column :personas, :mes, :integer
    add_column :personas, :dia, :integer
  end
end
