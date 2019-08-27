class AgregocampoANoDocentes < ActiveRecord::Migration
  def change
        add_column :cargo_no_docentes, :migracion_fecha, :date
        add_column :cargo_no_docentes, :estado_migrado, :string
  end
end
