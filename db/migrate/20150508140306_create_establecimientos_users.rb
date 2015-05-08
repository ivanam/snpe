class CreateEstablecimientosUsers < ActiveRecord::Migration
  def change
    create_table :establecimientos_users do |t|
      t.integer :establecimiento_id
      t.integer :user_id

      t.timestamps
    end
  end
end
