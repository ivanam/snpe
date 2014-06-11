class CreateSexos < ActiveRecord::Migration
  def change
    create_table :sexos do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
