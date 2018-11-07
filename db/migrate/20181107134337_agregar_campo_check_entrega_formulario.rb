class AgregarCampoCheckEntregaFormulario < ActiveRecord::Migration
  def change
      add_column :licencia, :con_formulario, :boolean
  end
end
