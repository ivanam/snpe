class CreatePermissions < ActiveRecord::Migration
  def change
    create_table :permissions do |t|
      t.integer :user_id
      t.string :nombre
      t.string :subject_class
      t.integer :subject_id
      t.string :action
      t.text :descripcion

      t.timestamps
    end
  end
end
