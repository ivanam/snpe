class AddNivelResolucionToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :nivel_id, :integer
    add_column :plans, :tipo_plan_id, :integer
    add_column :plans, :resolucion, :string
  end
end
