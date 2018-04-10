class CreateTipoPlans < ActiveRecord::Migration
  def change
    create_table :tipo_plans do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
