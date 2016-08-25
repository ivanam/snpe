class CreateEstablecimientoPlans < ActiveRecord::Migration
  def change
    create_table :establecimiento_plans do |t|
      t.references :establecimiento, index: true
      t.references :plan, index: true

      t.timestamps
    end
  end
end
