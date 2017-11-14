class AgregarRegionAPlanillaIncompatibilidad < ActiveRecord::Migration
  def change
    add_column :planilla_incompatibilidads, :region_id, :integer
    add_column :planilla_incompatibilidads, :incompatible, :boolean
  end
end
