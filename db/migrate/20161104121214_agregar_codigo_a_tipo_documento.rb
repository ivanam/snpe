class AgregarCodigoATipoDocumento < ActiveRecord::Migration
  def change
  	add_column :tipo_documentos, :codigo, :integer
  end
end
