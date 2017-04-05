class AgregarCamposACargosnds < ActiveRecord::Migration
  def change
  	add_column :cargo_no_docentes, :resolucion, :string
  	add_column :cargo_no_docentes, :decreto, :string
  end
end
