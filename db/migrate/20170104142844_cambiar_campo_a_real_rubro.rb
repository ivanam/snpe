class CambiarCampoARealRubro < ActiveRecord::Migration
 def up
  	change_column :rubros, :rubro_titulo, :float
  	change_column :rubros, :rubro_concepto, :float
  	change_column :rubros, :rubro_asis_perf, :float
  	change_column :rubros, :rubro_ser_prest, :float
  	change_column :rubros, :rubro_residencia, :float
  	change_column :rubros, :rubro_gestion, :float
  	change_column :rubros, :ant_doc, :float
  	change_column :rubros, :total, :float
  	change_column :rubros, :rubro_cursos, :float
  	change_column :rubros, :promedio, :float
  end

  def down
  	change_column :rubros, :rubro_titulo, :float
  	change_column :rubros, :rubro_concepto, :float
  	change_column :rubros, :rubro_asis_perf, :float
  	change_column :rubros, :rubro_ser_prest, :float
  	change_column :rubros, :rubro_residencia, :float
  	change_column :rubros, :rubro_gestion, :float
  	change_column :rubros, :ant_doc, :float
  	change_column :rubros, :total, :float
  	change_column :rubros, :rubro_cursos, :float
  	change_column :rubros, :promedio, :float
  end
end
