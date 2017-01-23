class AgregarCampoaTitulos < ActiveRecord::Migration
  def change
  	add_column :titulos, :alcance, :string
  	add_column :titulos, :tipotitulo, :string
  	add_column :titulos, :region, :string 
  	add_column :titulos, :comentario, :text
  end
end
